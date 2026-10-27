import { copyFile, mkdir, readFile, writeFile } from "node:fs/promises";
import { basename, dirname, resolve } from "node:path";

const [htmlArgument, cssArgument, jsArgument] = process.argv.slice(2);

if (!htmlArgument || !cssArgument || !jsArgument) {
  throw new Error(
    "Usage: node inject-arrival-effect.mjs <html> <arrival.css> <arrival.js>"
  );
}

const htmlPath = resolve(htmlArgument);
const cssPath = resolve(cssArgument);
const jsPath = resolve(jsArgument);
const distDirectory = dirname(htmlPath);
const assetDirectory = resolve(distDirectory, "assets");
const cssName = basename(cssPath);
const jsName = basename(jsPath);

const headStart = "<!-- orbital-arrival:head:start -->";
const headEnd = "<!-- orbital-arrival:head:end -->";
const bodyStart = "<!-- orbital-arrival:body:start -->";
const bodyEnd = "<!-- orbital-arrival:body:end -->";

const headFragment = `${headStart}
<script>
  (() => {
    try {
      if (new URLSearchParams(window.location.search).get("arrival") !== "wormhole") return;
      document.documentElement.setAttribute("data-orbital-arrival", "pending");
      window.__orbitalArrivalFallback = window.setTimeout(() => {
        document.documentElement.removeAttribute("data-orbital-arrival");
      }, 3000);
    } catch {}
  })();
</script>
<link rel="stylesheet" href="/assets/${cssName}">
${headEnd}`;

const bodyFragment = `${bodyStart}
<div id="orbital-arrival" aria-hidden="true"></div>
<svg id="orbital-arrival-filter" width="0" height="0" aria-hidden="true">
  <defs>
    <filter id="arrival-wave-distortion" x="-35%" y="-35%" width="170%" height="170%" color-interpolation-filters="sRGB">
      <feTurbulence type="fractalNoise" baseFrequency="0.012 0.042" numOctaves="2" seed="23" result="arrival-noise">
        <animate attributeName="baseFrequency" values="0.012 0.042;0.026 0.078;0.008 0.032" dur="1.2s" fill="freeze" />
      </feTurbulence>
      <feDisplacementMap in="SourceGraphic" in2="arrival-noise" scale="62" xChannelSelector="R" yChannelSelector="B">
        <animate attributeName="scale" values="62;44;18;0" keyTimes="0;0.35;0.72;1" dur="1.2s" fill="freeze" />
      </feDisplacementMap>
    </filter>
  </defs>
</svg>
<script src="/assets/${jsName}"></script>
${bodyEnd}`;

const removeInjectedFragment = (html, start, end) =>
  html.replace(new RegExp(`${start}[\\s\\S]*?${end}\\s*`, "g"), "");

let html = await readFile(htmlPath, "utf8");
html = removeInjectedFragment(html, headStart, headEnd);
html = removeInjectedFragment(html, bodyStart, bodyEnd);

if (!html.includes("</head>") || !html.includes("</body>")) {
  throw new Error(
    `Generated HTML is missing a complete document shell: ${htmlPath}`
  );
}

html = html.replace("</head>", `${headFragment}\n</head>`);
html = html.replace("</body>", `${bodyFragment}\n</body>`);

await mkdir(assetDirectory, { recursive: true });
await Promise.all([
  copyFile(cssPath, resolve(assetDirectory, cssName)),
  copyFile(jsPath, resolve(assetDirectory, jsName)),
]);
await writeFile(htmlPath, html);
