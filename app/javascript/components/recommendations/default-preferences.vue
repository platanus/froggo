<template>
  <button
    v-if="!noTeamsInOrganization"
    :class="`rounded-r-lg border-r border-t border-b p-3`"
    @click="setDefault"
  >
    <div
      v-if="success"
      class="text-green-500"
    >
      OK!
    </div>
    <div
      v-else
      class="text-black"
    >
      {{ $i18n.t('message.recommendations.setDefaultPreferences') }}
    </div>
  </button>
</template>
<script>

import { mapState } from 'vuex';

import preferencesApi from '../../api/preferences';

const TIMEOUT_IN_MS = 2000;

export default {
  props: {
    user: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      success: false,
      currentTimeout: null,
    };
  },
  computed: {
    ...mapState({
      selectedOrganization: state => state.preferences.organization,
      selectedTeam: state => state.preferences.team,
      selectedTimespan: state => state.preferences.timespan,
      noTeamsInOrganization: state => state.recommendations.noTeamsInOrganization,
    }),
  },
  methods: {
    clearCopyTimeout() {
      if (this.currentTimeout) {
        clearTimeout(this.currentTimeout);
      }
    },
    setCopyTimeout() {
      this.success = true;
      this.currentTimeout = setTimeout(() => {
        this.success = false;
      }, TIMEOUT_IN_MS);
    },
    async setDefault() {
      const body = {
        'default_organization_id': this.selectedOrganization.id,
        'default_team_id': this.selectedTeam.id,
        'default_time': this.selectedTimespan,
      };
      await preferencesApi.updatePreferences(this.user.id, body);
      this.clearCopyTimeout();
      this.setCopyTimeout();
    },
  },
};
</script>
