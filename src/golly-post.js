Viz.instance = new Viz.Module();
Viz.defaultOptions = { format: 'svg', engine: 'dot', files: [], images: [], yInvert: false, nop: 0 };

function viz(src, o) {
  const o2 = o ? Object.assign({}, Viz.defaultOptions, o) : Viz.defaultOptions;
  return Viz.render(Viz.instance, src, o2);
}
