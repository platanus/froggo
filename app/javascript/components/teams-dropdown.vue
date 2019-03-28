<template>
  <clickable-dropdown
    :body-title="dropdownTitle"
    :no-items-message="noTeamsMessage"
    :items="teams"
    :default-index="defaultTeamIndex"
    @item-clicked="onItemClicked"
  >
  </clickable-dropdown>
</template>

<script>
import ClickableDropdown from './clickable-dropdown';
import { PROCESS_NEW_TEAM } from '../store/action-types';

export default {
  props: {
    githubLogin: String,
    teams: Array,
  },
  data() {
    return {
      dropdownTitle: this.$t('message.profile.teamsDropdownTitle'),
      noTeamsMessage: this.$t('message.profile.noTeams'),
    };
  },
  updated() {
    const selectedTeam = this.teams[this.defaultTeamIndex];
    if (selectedTeam) {
      this.onTeamSelected(selectedTeam);
    }
  },
  computed: {
    defaultTeamIndex() {
      if (!localStorage.mapUserToDefaultTeam) {
        return 0;
      }
      const mapUserToDefaultTeam = JSON.parse(localStorage.mapUserToDefaultTeam);
      if (!mapUserToDefaultTeam.hasOwnProperty(this.githubLogin)) {
        return 0;
      }
      const teamId = mapUserToDefaultTeam[this.githubLogin];
      const index = this.teams.findIndex(team => team.id === teamId);
      if (index >= 0) {
        return index;
      }
      return 0;
    },
  },
  methods: {
    onItemClicked({ item }) {
      this.onTeamSelected(item);
      this.makeTeamDefault(item)
    },

    onTeamSelected(team) {
      this.$store.dispatch(PROCESS_NEW_TEAM, {
        teamId: team.id,
        organizationId: team.organization_id,
        githubUserLogin: this.githubLogin,
      });
    },

    makeTeamDefault(team) {
      const mapUserToDefaultTeam =
        localStorage.mapUserToDefaultTeam ?
          JSON.parse(localStorage.mapUserToDefaultTeam) :
          {};
      mapUserToDefaultTeam[this.githubLogin] = team.id;
      localStorage.mapUserToDefaultTeam = JSON.stringify(mapUserToDefaultTeam);
    },
  },
  components: {
    ClickableDropdown,
  },
};
</script>
