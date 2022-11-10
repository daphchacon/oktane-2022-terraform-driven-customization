const path = require('path');

module.exports = {
  mode: 'development',
  entry: {
    postLogin: './actions/postLogin.js'
  },
  output: {
    filename: '[name].js',
    path: path.resolve(__dirname, 'actions_out'),
    library: {
      // necessary to create exports.<actionFunction> module
      type: 'commonjs-static',
    },
  },
};