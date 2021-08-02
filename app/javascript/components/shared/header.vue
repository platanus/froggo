<template>
  <header class="px-6 py-3 bg-black">
    <div class="flex">
      <div class="flex items-center flex-1">
        <inline-svg
          :src="require('assets/images/froggo-logo.svg').default"
          class="h-6"
        />
      </div>
      <div class="flex items-center">
        <dropdown-organization
          :organizations="organizations"
          :user="user"
        />
        <div
          class="h-8 mr-8 border-r-2 border-white"
        />
        <froggo-dropdown align="right">
          <template #btn>
            <div class="flex items-center">
              <img
                :src="user.avatar_url"
                class="w-10 h-10 mr-1 rounded-full"
              >
              <inline-svg
                :src="require('assets/images/chevron-down.svg').default"
                class="text-white fill-current h-6 w-6 ml-2"
              />
            </div>
          </template>
          <template #body>
            <div class="mt-4 bg-white w-56">
              <div class="grid grid-rows-auto gap-1 font-medium whitespace-no-wrap">
                <a
                  href="/me"
                  class="p-4"
                >
                  {{ $i18n.t('message.global.header.profile') }}
                </a>
                <a
                  :href="organizationPath"
                  class="p-4"
                >
                  {{ $i18n.t('message.global.header.organizations') }}
                </a>
                <a
                  :href="orgAuthenticatePath"
                  class="p-4"
                >
                  {{ $i18n.t('message.global.header.givePermission') }}
                </a>
                <a
                  :href="closeSessionPath"
                  class="p-4"
                >
                  {{ $i18n.t('message.global.header.closeSession') }}
                </a>
              </div>
            </div>
          </template>
        </froggo-dropdown>
      </div>
    </div>
  </header>
</template>
<script>
import { LOAD_DEFAULT_PREFERENCES, LOAD_RECOMMENDATIONS } from '../../store/action-types';
import { SET_FETCHING_DEFAULT_PREFERENCES, SET_FETCHING_RECOMMENDATIONS } from '../../store/mutation-types';

import DropdownOrganization from './dropdown-organization.vue';

export default {
  components: {
    DropdownOrganization,
  },
  props: {
    user: {
      type: Object,
      required: true,
    },
    organizations: {
      type: Array,
      default: () => [],
    },
    organizationPath: {
      type: String,
      default: '',
    },
    orgAuthenticatePath: {
      type: String,
      default: '',
    },
    closeSessionPath: {
      type: String,
      default: '',
    },
  },
  async beforeMount() {
    this.$store.commit(SET_FETCHING_DEFAULT_PREFERENCES, true);
    await this.$store.dispatch(LOAD_DEFAULT_PREFERENCES, this.user.id);
    this.$store.commit(SET_FETCHING_DEFAULT_PREFERENCES, false);

    this.$store.commit(SET_FETCHING_RECOMMENDATIONS, true);
    await this.$store.dispatch(LOAD_RECOMMENDATIONS, this.user.login);
    this.$store.commit(SET_FETCHING_RECOMMENDATIONS, false);
  },
};
</script>
