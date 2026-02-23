"use client";

import { useRef, useState } from "react";

export function VideoPlaceholderSection() {
  const videoRef = useRef<HTMLVideoElement | null>(null);
  const [isPlaying, setIsPlaying] = useState(false);

  const handlePlayClick = () => {
    if (!videoRef.current) return;
    void videoRef.current.play();
  };

  return (
    <section className="bg-[#D4FF00] px-6 pb-28 md:px-12 md:pb-36">
      <div className="mx-auto w-fit max-w-full">
        <div className="relative w-[1440px] max-w-full overflow-hidden rounded-3xl border-4 border-[#0A0A0A] bg-white shadow-[10px_10px_0_0_#0A0A0A]">
          <video
            ref={videoRef}
            className="block h-auto w-full"
            controls
            playsInline
            preload="metadata"
            aria-label="Open Yapper demo video"
            onPlay={() => setIsPlaying(true)}
            onPause={() => setIsPlaying(false)}
            onEnded={() => setIsPlaying(false)}
          >
            <source src="/Final%20open%20yapper%20demo.mp4" type="video/mp4" />
            Your browser does not support the video tag.
          </video>
          {!isPlaying && (
            <button
              type="button"
              onClick={handlePlayClick}
              className="absolute inset-0 flex items-center justify-center"
              aria-label="Play demo video"
            >
              <span className="flex h-32 w-32 items-center justify-center rounded-full border-4 border-[#0A0A0A] bg-[#D4FF00] shadow-[8px_8px_0_0_#0A0A0A] transition-transform hover:scale-105 md:h-40 md:w-40">
                <span className="ml-1 h-0 w-0 border-y-[18px] border-y-transparent border-l-[28px] border-l-[#0A0A0A] md:border-y-[22px] md:border-l-[34px]" />
              </span>
            </button>
          )}
        </div>
      </div>
    </section>
  );
}
