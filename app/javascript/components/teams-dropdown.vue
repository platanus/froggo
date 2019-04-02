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
import FroggoLocalStorage from '../helpers/local-storage';

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
  mounted() {
    const selectedTeam = this.teams[this.defaultTeamIndex];
    if (selectedTeam) {
      this.onTeamSelected(selectedTeam);
    }
  },
  computed: {
    defaultTeamIndex() {
      return this.getDefaultTeamIndex();
    },
  },
  methods: {
    getDefaultTeamIndex() {
      return FroggoLocalStorage.get(
        "mapUserToDefaultTeam",
        this.githubLogin,
        this.teams
      );
    },

    onItemClicked({ item }) {
      this.onTeamSelected(item);
      this.makeTeamDefault(item);
    },

    onTeamSelected(team) {
      this.$store.dispatch(PROCESS_NEW_TEAM, {
        teamId: team.id,
        organizationId: team.organization_id,
        githubUserLogin: this.githubLogin,
      });
    },

    makeTeamDefault(team) {
      FroggoLocalStorage.set(
        "mapUserToDefaultTeam",
        this.githubLogin,
        team.id
      )
    },
  },
  components: {
    ClickableDropdown,
  },
};
</script>
