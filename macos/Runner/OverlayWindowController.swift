import Cocoa
import SwiftUI
import Carbon.HIToolbox

class OverlayWindowController {
    private var panel: NSPanel?
    private var pillState = PillState()
    private var escapeMonitor: Any?
    var onCancel: (() -> Void)?

    class PillState: ObservableObject {
        @Published var state: String = "recording"  // "recording", "processing", "success"
        @Published var audioLevel: Float = 0.0
        @Published var duration: TimeInterval = 0
    }

    func show(state: String) {
        guard let screen = NSScreen.main else { return }

        let pillWidth: CGFloat = 180
        let pillHeight: CGFloat = 44
        let bottomPadding: CGFloat = 88

        let xOrigin = (screen.frame.width - pillWidth) / 2 + screen.frame.origin.x
        let yOrigin = screen.frame.origin.y + bottomPadding

        pillState.state = state
        pillState.audioLevel = 0
        pillState.duration = 0

        let pillView = NativeRecordingPillView(pillState: pillState)
        #if DEBUG
        print("[Overlay] Showing compact dark pill (180×44, black 0.75)")
        #endif
        let hostingView = NSHostingView(rootView: pillView)

        let panel = NSPanel(
            contentRect: NSRect(x: xOrigin, y: yOrigin, width: pillWidth, height: pillHeight),
            styleMask: [.nonactivatingPanel, .borderless],
            backing: .buffered,
            defer: false
        )

        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = false
        panel.appearance = NSApp.effectiveAppearance
        panel.level = .screenSaver
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        panel.isMovableByWindowBackground = false
        panel.ignoresMouseEvents = false
        panel.hidesOnDeactivate = false
        panel.contentView = hostingView

        // Animate in: slide up + fade in
        panel.alphaValue = 0
        let finalFrame = panel.frame
        var startFrame = finalFrame
        startFrame.origin.y -= 40
        panel.setFrame(startFrame, display: false)
        panel.makeKeyAndOrderFront(nil)

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.4
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            panel.animator().alphaValue = 1
            panel.animator().setFrame(finalFrame, display: true)
        }

        self.panel = panel

        // Listen for Escape key to cancel
        escapeMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self, event.keyCode == UInt16(kVK_Escape), self.panel != nil else {
                return event
            }
            if pillState.state != "success" {
                onCancel?()
                return nil  // Consume the event
            }
            return event
        }
    }

    func updateState(_ state: String) {
        DispatchQueue.main.async { self.pillState.state = state }

        if state == "success" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                self?.dismiss()
            }
        }
    }

    func updateAudioLevel(_ level: Float) {
        DispatchQueue.main.async { self.pillState.audioLevel = level }
    }

    func updateDuration(_ duration: TimeInterval) {
        DispatchQueue.main.async { self.pillState.duration = duration }
    }

    func dismiss() {
        guard let panel else { return }
        if let monitor = escapeMonitor {
            NSEvent.removeMonitor(monitor)
            escapeMonitor = nil
        }
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.3
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            panel.animator().alphaValue = 0
            var frame = panel.frame
            frame.origin.y -= 40
            panel.animator().setFrame(frame, display: true)
        }, completionHandler: { [weak self] in
            self?.panel?.close()
            self?.panel = nil
        })
    }
}
