const path = require('path');

module.exports = {
  entry: path.join(__dirname, './index.tsx'),
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
      },
      {
        test:/\.(s*)css$/,
        use:['style-loader','css-loader', 'sass-loader']
      },
      {
        test: /\.(png|woff|woff2|eot|ttf|svg)$/,
        loader: 'url-loader?limit=100000'
      },
      {
        test: /\.(ico|jpe?g|png|gif|webp|svg|mp4|webm|wav|mp3|m4a|aac|oga)(\?.*)?$/,
        loader: "file-loader"
      }
    ]
  }
};
