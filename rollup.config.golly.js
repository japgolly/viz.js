import {terser} from 'rollup-plugin-terser';

export default {
  input: '/tmp/viz.golly.js',
  output: {
    name: 'Viz',
    file: 'viz.golly.js',
    format: 'iife'
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
