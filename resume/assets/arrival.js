(() => {
  const root = document.documentElement;
  if (!root.hasAttribute("data-orbital-arrival")) return;

  const finishArrival = () => {
    root.removeAttribute("data-orbital-arrival");
    window.clearTimeout(window.__orbitalArrivalFallback);

    const url = new URL(window.location.href);
    if (url.searchParams.get("arrival") === "wormhole") {
      url.searchParams.delete("arrival");
      window.history.replaceState(
        {},
        "",
        `${url.pathname}${url.search}${url.hash}`
      );
    }
  };

  const beginArrival = () => {
    const overlay = document.querySelector("#orbital-arrival");
    if (!overlay) {
      finishArrival();
      return;
    }

    window.clearTimeout(window.__orbitalArrivalFallback);
    window.requestAnimationFrame(() => {
      window.requestAnimationFrame(() => {
        root.setAttribute("data-orbital-arrival", "active");
        const reducedMotion = window.matchMedia(
          "(prefers-reduced-motion: reduce)"
        ).matches;
        window.setTimeout(finishArrival, reducedMotion ? 170 : 1280);
      });
    });
  };

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", beginArrival, { once: true });
  } else {
    beginArrival();
  }
})();
