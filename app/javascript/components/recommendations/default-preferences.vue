<template>
  <froggo-button
    v-if="!noTeamsInOrganization"
    @click="setDefault"
    :variant="this.variant"
    :recommendation="this.recommendation"
  >
    <div
      v-if="success"
    >
      OK!
    </div>
    <div
      v-else
    >
      {{ $i18n.t('message.recommendations.setDefaultPreferences') }}
    </div>
  </froggo-button>
</template>
<script>

import { mapState } from 'vuex';

import FroggoButton from '../shared/froggo-button.vue';
import preferencesApi from '../../api/preferences';

const TIMEOUT_IN_MS = 2000;

export default {
  component: {
    FroggoButton,
  },
  props: {
    user: {
      type: Object,
      required: true,
    },
    variant: { type: String, default: 'black' },
    recommendation: { type: Boolean, default: true },
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
