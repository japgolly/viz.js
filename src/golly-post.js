class ModuleWrapper {
  constructor(module, render) {
    let instance = undefined;
    let initialized = false;
    let moduleInitialization = new Promise((resolve, reject) => {
      try {
        instance = module();
        instance['onRuntimeInitialized'] = () => {
          initialized = true;
          resolve();
        };
      } catch (error) {
        reject(error)
      }
    });

    this.render = async (src, options) => {
      if (!initialized) {
        await moduleInitialization;
      }
      try {
        return render(instance, src, options);
      } catch (err) {
        // The instance is left in a broken state on error.
        // We have to create a new instance for subsequent calls to work.
        instance = module();
        throw err;
      }
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
