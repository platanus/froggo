<template>
  <froggo-dropdown align="right">
    <template #btn>
      <div class="flex items-center mr-8">
        <img
          v-if="!fetchingDefaultPreferences && selectedOrganization.avatar_url"
          :src="selectedOrganization.avatar_url"
          class="h-10 w-10 mr-1 rounded-full"
        >
        <span
          v-else
          class="w-10 h-10 mr-1 rounded-full bg-white bg-opacity-50"
        />
        <inline-svg
          :src="require('assets/images/chevron-down.svg').default"
          class="text-white fill-current h-6 w-6 ml-2"
        />
      </div>
    </template>
    <template #body>
      <div class="mt-4 bg-white w-56">
        <div
          v-if="organizations"
          class="grid grid-rows-auto gap-1"
        >
          <div
            v-for="organization in organizations"
            :key="organization.id"
            class="flex items-center m-4 cursor-pointer"
            @click="selectOrganization(organization)"
          >
            <img
              v-if="organization.avatar_url"
              :src="organization.avatar_url"
              class="h-10 w-10 mr-5 rounded-full"
            >
            <span
              v-else
              class="h-10 w-10 mr-5 rounded-full bg-black bg-opacity-25"
            />
            <p class="my-auto font-medium">
              {{ organization.login }}
            </p>
          </div>
        </div>
        <div
          v-else
          class="flex items-center p-4"
        >
          <p class="my-auto font-medium">
            {{ $i18n.t('message.global.header.noOrganizations') }}
          </p>
        </div>
      </div>
    </template>
  </froggo-dropdown>
</template>

<script>

import { mapState } from 'vuex';

import { SET_NO_ORGANIZATIONS, SET_ORGANIZATION } from '../../store/mutation-types';

export default {
  props: {
    organizations: {
      type: Array,
      default: () => [],
    },
    user: {
      type: Object,
      required: true,
    },
  },
  created() {
    if (!this.organizations.length) this.$store.commit(SET_NO_ORGANIZATIONS, true);
  },
  computed: {
    ...mapState({
      selectedOrganization: state => state.preferences.organization,
      fetchingDefaultPreferences: state => state.preferences.fetchingDefaultPreferences,
    }),
  },
  methods: {
    selectOrganization(organization) {
      this.$store.commit(SET_ORGANIZATION, organization);
    },
  },
};
</script>
