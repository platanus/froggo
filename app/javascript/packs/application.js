/* eslint no-console: 0 */

import Vue from 'vue/dist/vue.esm';
import VueI18n from 'vue-i18n';
import vSelect from 'vue-select';
import Repository from '../repository.vue';
import Dropdown from 'bp-vuejs-dropdown';
import Locales from '../locales.js';

Vue.use(VueI18n);

document.addEventListener('DOMContentLoaded', () => {

  Vue.component('repository', Repository);
  Vue.component('v-select', vSelect);
  Vue.component('dropdown', Dropdown);

  new Vue({ // eslint-disable-line no-new
    el: '#app',
    i18n: new VueI18n({
      locale: 'es',
      messages: Locales.messages,
    }),
    data: {
      activeOrg: null,
    },
    methods: {
      changeOrganization(organization) {
        if(organization === null) return false;
        if(this.activeOrg !== organization.login)
          document.location.href = `/organizations/${organization.login}`;
      },
    },
    beforeMount() {
      let pathArray = window.location.pathname.split('/');
      if(pathArray.length > 2 && pathArray[1] === 'organizations')
        this.activeOrg = pathArray[2];
    },
  });
});
