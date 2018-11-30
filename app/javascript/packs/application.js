/* eslint no-console: 0 */
/* global document, window */

import Vue from 'vue/dist/vue.esm';
import VueI18n from 'vue-i18n';
import Dropdown from '../pl-dropdown.vue';
import Repository from '../repository.vue';
import EnablePublicButton from '../enable-public-button.vue';
import Locales from '../locales.js';
import SyncOrganizationButton from '../sync-organization-button.vue';

Vue.use(VueI18n);

document.addEventListener('DOMContentLoaded', () => {
  Vue.component('repository', Repository);
  Vue.component('enable-public-button', EnablePublicButton);
  Vue.component('dropdown', Dropdown);
  Vue.component('sync-organization-button', SyncOrganizationButton);

  if (document.getElementById('app') !== null) {
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
          if (organization === null) {
            return;
          }
          if (this.activeOrg !== organization.login) {
            document.location.href = `/organizations/${organization.login}`;
          }

          return;
        },
      },
      beforeMount() {
        const pathArray = window.location.pathname.split('/');
        const orgNameUrlPos = 1;
        if (pathArray.length > orgNameUrlPos + 1 && pathArray[orgNameUrlPos] === 'organizations') {
          this.activeOrg = pathArray[orgNameUrlPos + 1];
        }
      },
    });
  }
});

