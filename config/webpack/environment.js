const { environment } = require('@rails/webpacker');
const path = require('path');
const { VueLoaderPlugin } = require('vue-loader');
const vue = require('./loaders/vue');

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin());
environment.loaders.prepend('vue', vue);
environment.config.merge({
  resolve: {
    alias: {
      assets: path.resolve('./app/assets'),
    },
  },
});
module.exports = environment;
