/* eslint no-console: 0 */

import Vue from 'vue';
import VueI18n from 'vue-i18n';
import App from '../app.vue';
import Locales from '../locales.js';

Vue.use(VueI18n);

document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('selector').appendChild(document.createElement('selector'));
  const app = new Vue({
    render: h => h(App),
    i18n: new VueI18n({
      locale: 'es',
      messages: Locales.messages,
    }),
  }).$mount('selector');
});

