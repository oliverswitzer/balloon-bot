const path = require('path');

module.exports = {
  entry: path.join(__dirname, './incidents/index.tsx'),
  resolve: {
    extensions: [ '.tsx', '.ts', '.jsx', '.js' ]
  },
  devtool: 'inline-source-map',
  output: {
    path: path.join(__dirname, '../public/scripts'),//p,
    filename: 'bundle.min.js'
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: 'ts-loader',
        exclude: /node_modules/
      }
    ]
  }
};
