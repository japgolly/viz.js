vizWasmFile = '../dist/viz.wasm';
self.importScripts(["../dist/viz.js"]);

console.log("[ww] Viz: ", Viz)
console.log("[ww] viz: ", viz)

function sendBack(m) {
  console.log(`[ww] Sending back: ${JSON.stringify(m)}`);
  postMessage(m);
}

onmessage = function(e) {
  console.log('[ww] Message received: ', e.data);
  viz(e.data).then(sendBack);
}

viz("").then((e) => postMessage("ready"));
