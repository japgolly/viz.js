class ModuleWrapper {
  constructor(module, render) {
    let instance = undefined;
    let initialized = false;
    let moduleInitialization = new Promise((resolve, reject) => {
      instance = module();
      instance['onRuntimeInitialized'] = () => {
        initialized = true;
        resolve();
      };
    });

    this.render = async (src, options) => {
      if (!initialized) {
        await moduleInitialization;
      }
      return render(instance, src, options);
    }
  }
}

const wrapper = new ModuleWrapper(Viz.Module, Viz.render)

const defaultOptions = {
  format : 'svg',
  engine : 'dot',
  files  : [],
  images : [],
  yInvert: false,
  nop    : 0,
};

function viz(src, opts) {
  const o = opts ? Object.assign({}, defaultOptions, opts) : defaultOptions;
  return wrapper.render(src, o);
}

global.viz = viz;
