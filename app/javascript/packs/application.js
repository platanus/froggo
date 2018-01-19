/* eslint no-console: 0 */

import Vue from 'vue';
import App from '../app.vue';

document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('selector').appendChild(document.createElement('selector'));
  const app = new Vue({
    render: h => h(App)
  }).$mount('selector');
})




