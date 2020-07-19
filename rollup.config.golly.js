import {terser} from 'rollup-plugin-terser';

export default {
  input: 'target/golly/viz.js',
  output: {
    file: 'dist/viz.js',
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
