/* eslint no-console: 0 */

import Vue from 'vue';
import Selector from '../app.vue';
import ConfigPanel from '../panel.vue';

document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('selector').appendChild(document.createElement('selector'));
  new Vue({
    render: h => h(Selector),
  }).$mount('selector');

  document.getElementById('panel').appendChild(document.createElement('panel'));
  new Vue({
    render: h => h(ConfigPanel),
  }).$mount('panel');
});

