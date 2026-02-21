import Cocoa
import Carbon.HIToolbox

struct HotkeySpec {
    let keyCode: Int
    let flags: UInt64

    func matches(keyCode: Int64, flags: CGEventFlags) -> Bool {
        guard keyCode == self.keyCode else { return false }
        let mask: CGEventFlags = [.maskShift, .maskControl, .maskAlternate, .maskCommand]
        return (flags.intersection(mask).rawValue) == UInt64(self.flags)
    }
}

class HotkeyManager {
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private var config: (start: HotkeySpec, stop: HotkeySpec, hold: HotkeySpec) = (
        start: HotkeySpec(keyCode: Int(kVK_Space), flags: 0x80000),
        stop: HotkeySpec(keyCode: Int(kVK_Return), flags: 0x80000),
        hold: HotkeySpec(keyCode: Int(kVK_Space), flags: 0x40000)
    )

    var onStartPressed: (() -> Void)?
    var onStopPressed: (() -> Void)?
    var onHoldDown: (() -> Void)?
    var onHoldUp: (() -> Void)?
    private var isStopHotkeyEnabled = false
    /// Tracks when hold key was pressed so we can reliably detect release even if modifier flags differ.
    private var holdKeyIsDown = false

    /// When set, the next key press is captured and sent here instead of triggering hotkeys.
    var onCaptureNextKey: ((Int, UInt64) -> Void)?

    func setConfig(startKeyCode: Int, startFlags: UInt64, stopKeyCode: Int, stopFlags: UInt64, holdKeyCode: Int, holdFlags: UInt64) {
        config = (
            start: HotkeySpec(keyCode: startKeyCode, flags: startFlags),
            stop: HotkeySpec(keyCode: stopKeyCode, flags: stopFlags),
            hold: HotkeySpec(keyCode: holdKeyCode, flags: holdFlags)
        )
    }

    func setStopHotkeyEnabled(_ enabled: Bool) {
        isStopHotkeyEnabled = enabled
    }

    func start() {
        let eventMask: CGEventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue)

        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMask,
            callback: { proxy, type, event, refcon in
                let manager = Unmanaged<HotkeyManager>.fromOpaque(refcon!).takeUnretainedValue()
                return manager.handleEvent(proxy: proxy, type: type, event: event)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        )

        guard let eventTap else {
            print("⚠️ Failed to create event tap — Accessibility permission likely not granted")
            return
        }
        runLoopSource = CFMachPortCreateRunLoopSource(nil, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
    }

    private func handleEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
            if holdKeyIsDown {
                holdKeyIsDown = false
                DispatchQueue.main.async { self.onHoldUp?() }  // Likely missed keyUp while tap was disabled
            }
            if let eventTap { CGEvent.tapEnable(tap: eventTap, enable: true) }
            return Unmanaged.passRetained(event)
        }

        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        let flags = event.flags

        // Capture mode: send next key to Flutter and consume
        if let capture = onCaptureNextKey {
            if type == .keyDown {
                let mask: CGEventFlags = [.maskShift, .maskControl, .maskAlternate, .maskCommand]
                let flagsValue = flags.intersection(mask).rawValue
                DispatchQueue.main.async { capture(Int(keyCode), flagsValue) }
                onCaptureNextKey = nil
                return nil
            }
            return Unmanaged.passRetained(event)
        }

        if type == .keyDown {
            if config.start.matches(keyCode: keyCode, flags: flags) {
                DispatchQueue.main.async { self.onStartPressed?() }
                return nil
            }
            if isStopHotkeyEnabled && config.stop.matches(keyCode: keyCode, flags: flags) {
                DispatchQueue.main.async { self.onStopPressed?() }
                return nil
            }
            if config.hold.matches(keyCode: keyCode, flags: flags) {
                holdKeyIsDown = true
                DispatchQueue.main.async { self.onHoldDown?() }
                return nil
            }
        } else if type == .keyUp {
            // Match by keyCode only when we've tracked a hold-down. Modifier flags on keyUp
            // can differ (e.g. user releases Ctrl before Space), causing us to miss the release.
            if holdKeyIsDown && Int(keyCode) == config.hold.keyCode {
                holdKeyIsDown = false
                DispatchQueue.main.async { self.onHoldUp?() }
                return nil
            }
        }

        return Unmanaged.passRetained(event)
    }

    func stop() {
        if let eventTap { CGEvent.tapEnable(tap: eventTap, enable: false) }
        if let runLoopSource { CFRunLoopRemoveSource(CFRunLoopGetMain(), runLoopSource, .commonModes) }
    }
}
