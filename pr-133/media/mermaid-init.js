/* Render Mermaid diagrams on initial load and after Material instant navigation. */
if (typeof window.mermaid !== "undefined") {
  window.mermaid.initialize({
    startOnLoad: false,
    securityLevel: "strict",
  });
}

if (typeof document$ !== "undefined") {
  document$.subscribe(function () {
    if (typeof window.mermaid === "undefined") {
      return;
    }

    // Allow re-rendering after instant navigation by clearing previous markers.
    document.querySelectorAll("pre.mermaid").forEach(function (el) {
      el.removeAttribute("data-processed");
    });

    window.mermaid.run({
      querySelector: "pre.mermaid",
    });
  });
}
