<template>
  <froggo-dropdown>
    <template #btn>
      <div class="flex items-center justify-between p-3 py-4 mt-1 border rounded-lg">
        <div v-if="fetchingDefaultPreferences">
          {{ $i18n.t('message.recommendations.loading') }}
        </div>
        <div v-else-if="noTeamsInOrganization">
          {{ $i18n.t('message.recommendations.noTeams') }}
        </div>
        <div v-else>
          {{ selectedTeam.name }}
        </div>
        <inline-svg
          :src="require('../../../assets/images/chevron-down.svg').default"
          class="text-black fill-current h-6 w-6 ml-2"
        />
      </div>
    </template>
    <template #body>
      <div
        class="bg-white"
        slot="body"
      >
        <div class="grid grid-rows-auto gap-1 font-medium whitespace-no-wrap">
          <div
            v-for="team in selectedOrganizationTeams"
            :key="team.id"
            class="p-4 cursor-pointer"
            @click="selectTeam(team)"
          >
            {{ team.name }}
          </div>
        </div>
      </div>
    </template>
  </froggo-dropdown>
</template>
<script>

import { mapState } from 'vuex';
import { LOAD_RECOMMENDATIONS } from '../../store/action-types';
import { SET_FETCHING_RECOMMENDATIONS, SET_NO_TEAMS_IN_ORGANIZATION, SET_TEAM } from '../../store/mutation-types';

export default {
  props: {
    teams: {
      type: Array,
      default: () => [],
    },
    login: {
      type: String,
      required: true,
    },
  },
  computed: {
    ...mapState({
      selectedTeam: state => state.preferences.team,
      selectedOrganization: state => state.preferences.organization,
      fetchingDefaultPreferences: state => state.preferences.fetchingDefaultPreferences,
      noTeamsInOrganization: state => state.recommendations.noTeamsInOrganization,
    }),
    selectedOrganizationTeams() {
      if (!this.selectedOrganization) return [];

      return this.teams.filter(team => team.organization_id === this.selectedOrganization.id);
    },
  },
  methods: {
    async selectTeam(team) {
      this.$store.commit(SET_TEAM, team);

      this.$store.commit(SET_FETCHING_RECOMMENDATIONS, true);
      await this.$store.dispatch(LOAD_RECOMMENDATIONS, this.login);
      this.$store.commit(SET_FETCHING_RECOMMENDATIONS, false);
    },
  },
  watch: {
    selectedOrganization(organization, oldOrganization) {
      if (!oldOrganization) return;

      const teams = this.selectedOrganizationTeams;
      if (teams.length) this.selectTeam(teams[0]);
    },

    selectedOrganizationTeams(teams, oldTeams) {
      if (!oldTeams) return;

      if (teams.length) {
        this.$store.commit(SET_NO_TEAMS_IN_ORGANIZATION, false);
      } else {
        this.$store.commit(SET_NO_TEAMS_IN_ORGANIZATION, true);
      }
    },
  },
};
</script>
