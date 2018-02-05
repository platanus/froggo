/* eslint no-console: 0 */

import Vue from 'vue/dist/vue.esm';
import VueI18n from 'vue-i18n';
import Selector from '../selector.vue';
import Repository from '../repository.vue';
import Locales from '../locales.js';

Vue.use(VueI18n);

document.addEventListener('DOMContentLoaded', () => {

  Vue.component('selector', Selector);
  Vue.component('repository', Repository);

  new Vue({ // eslint-disable-line no-new
    el: '#app',
    i18n: new VueI18n({
      locale: 'es',
      messages: Locales.messages,
    }),
  });
});
