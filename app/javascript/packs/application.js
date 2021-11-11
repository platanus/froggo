/* eslint no-console: 0 */
/* global document, window */
import 'vue-multiselect/dist/vue-multiselect.min.css';
import Vue from 'vue/dist/vue.esm';
import VueI18n from 'vue-i18n';
import VTooltip from 'v-tooltip';
import Multiselect from 'vue-multiselect';
import VueHorizontalList from 'vue-horizontal-list';
import { InlineSvgPlugin } from 'vue-inline-svg';
import Toasted from 'vue-toasted';
import { camelizeKeys } from 'humps';
import vSelect from 'vue-select';
import VModal from 'vue-js-modal';
import VueClipboard from 'vue-clipboard2';
import '../css/application.css';

import FroggoHeader from '../components/shared/header.vue';
import FroggoSidebar from '../components/shared/sidebar.vue';

import Recommendations from '../components/recommendations/index.vue';

import FroggoDropdown from '../components/froggo-dropdown.vue';

import Dropdown from '../components/pl-dropdown.vue';
import TeamsDropdown from '../components/teams-dropdown.vue';
import OrganizationsDropdown from '../components/organizations-dropdown.vue';
import FroggoTeamEdit from '../components/froggo-team-edit.vue';
import FroggoTeamForm from '../components/froggo-team-form.vue';
import FroggoTeamShow from '../components/froggo-team-show.vue';
import FroggoTeamsList from '../components/froggo-teams-list.vue';
import TimespanDropdown from '../components/timespan-dropdown.vue';
import Repository from '../components/repository.vue';
import SyncOrganizationButton from '../components/sync-organization-button.vue';
import DashboardSyncingIcon from '../components/dashboard-syncing-icon.vue';
import ProfileDropdowns from '../components/profile-dropdowns.vue';
import OpenPr from '../components/open-pr.vue';
import ProfileRecommendations from '../components/profile/recommendations.vue';
import PrFeed from '../components/pr-feed.vue';
import PrShow from '../components/pr-show.vue';
import ProfileMetrics from '../components/profile/metrics.vue';
import ProfileCard from '../components/profile-card.vue';
import FroggoTeamMetrics from '../components/froggo-team-metrics.vue';
import PercentageDropdown from '../components/percentage-dropdown.vue';
import ProfileDescription from '../components/profile-description.vue';
import TagsShow from '../components/tags-show';
import UserTags from '../components/user-tags.vue';
import TeamTagsContainer from '../components/profile/team-tags-container.vue';

import Locales from '../locales/locales.js';
import store from '../store';

Vue.use(VueI18n);
Vue.use(VTooltip);
Vue.use(VueHorizontalList);
Vue.use(InlineSvgPlugin);
Vue.use(VModal, { dynamic: true, injectModalsContainer: true });
Vue.filter('camelizeKeys', camelizeKeys);

/* eslint-disable max-statements */
document.addEventListener('DOMContentLoaded', () => {
  Vue.use(Toasted, {
    action: {
      icon: 'close',
      onClick: (e, toastObject) => {
        toastObject.goAway(0);
      },
    },
  });
  Vue.component('Multiselect', Multiselect);
  Vue.component('recommendations', Recommendations);
  Vue.component('froggo-header', FroggoHeader);
  Vue.component('froggo-sidebar', FroggoSidebar);
  Vue.component('repository', Repository);
  Vue.component('dropdown', Dropdown);
  Vue.component('teams-dropdown', TeamsDropdown);
  Vue.component('organizations-dropdown', OrganizationsDropdown);
  Vue.component('froggo-dropdown', FroggoDropdown);
  Vue.component('froggo-team-edit', FroggoTeamEdit);
  Vue.component('froggo-team-form', FroggoTeamForm);
  Vue.component('froggo-team-show', FroggoTeamShow);
  Vue.component('froggo-teams-list', FroggoTeamsList);
  Vue.component('timespan-dropdown', TimespanDropdown);
  Vue.component('sync-organization-button', SyncOrganizationButton);
  Vue.component('dashboard-syncing-icon', DashboardSyncingIcon);
  Vue.component('profile-dropdowns', ProfileDropdowns);
  Vue.component('open-pr', OpenPr);
  Vue.component('profile-recommendations', ProfileRecommendations);
  Vue.component('pr-feed', PrFeed);
  Vue.component('pr-show', PrShow);
  Vue.component('profile-metrics', ProfileMetrics);
  Vue.component('profile-card', ProfileCard);
  Vue.component('froggo-team-metrics', FroggoTeamMetrics);
  Vue.component('percentage-dropdown', PercentageDropdown);
  Vue.component('profile-description', ProfileDescription);
  Vue.component('user-tags', UserTags);
  Vue.component('tags-show', TagsShow);
  Vue.component('v-select', vSelect);
  Vue.component('team-tags-container', TeamTagsContainer);
  Vue.use(VueClipboard);

  if (document.getElementById('app') !== null) {
    new Vue({ // eslint-disable-line no-new
      el: '#app',
      i18n: new VueI18n({
        locale: 'es',
        messages: Locales.messages,
      }),
      store,
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
