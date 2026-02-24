export type CtaEventType = "download_click" | "github_click";

export function trackCtaClick(type: CtaEventType, location: string) {
  if (typeof window === "undefined" || !window.gtag) return;

  window.gtag("event", type, {
    location,
  });
}
