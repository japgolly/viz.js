import {terser} from 'rollup-plugin-terser';

export default {
  input: '/tmp/viz.golly.js',
  output: {
    file: 'viz.golly.js',
    format: 'iife',
    compact: true,
    interop: false,
    externalLiveBindings: false
  },
  context: 'window',
  plugins: [
    terser({
      output: {
        comments: false,
        semicolons: false,
      },
    }),
  ]
};
