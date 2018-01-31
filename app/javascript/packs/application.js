/* eslint no-console: 0 */

import Vue from 'vue';
import VueI18n from 'vue-i18n';
import Selector from '../selector.vue';
import Locales from '../locales.js';

Vue.use(VueI18n);

document.addEventListener('DOMContentLoaded', () => {

  let renderElement = null;
  let idElement = '';

  if (document.getElementById('selector')) {
    renderElement = Selector;
    idElement = '#selector';
  }

  new Vue({
    render: h => h(renderElement),
    i18n: new VueI18n({
      locale: 'es',
      messages: Locales.messages,
    }),
  }).$mount(idElement);
});
