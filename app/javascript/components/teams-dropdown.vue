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
import { UPDATE_DEFAULT_TEAM } from '../store/action-types';

export default {
  props: {
    teams: Array,
    githubLogin: String,
    organization: Object,
    adminMode: {
      type: Boolean,
      default: false
    }
  },
  data() {
    const dropdownTitle = this.adminMode ?
      this.$t('message.admin.defaultTeamDropdownTitle') :
      this.$t('message.profile.teamsDropdownTitle');
    const noTeamsMessage = this.adminMode ?
      this.$t('message.admin.noDefaultTeam') :
      this.$t('message.profile.noTeams');
    return {
      dropdownTitle,
      noTeamsMessage,
    }
  },
  mounted() {
    if (!this.adminMode) {
      const selectedTeam = this.teams[this.defaultTeamIndex];
      if (selectedTeam) {
        this.onTeamSelected(selectedTeam);
      }
    }
  },

  computed: {
    defaultTeamIndex() {
      if (this.adminMode) {
        const defaultTeamId = this.organization.default_team_id;
        return defaultTeamId ? this.teams.findIndex(team => team.id === defaultTeamId) : -1;
      }
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
      if (this.adminMode){
        this.onDefaultTeamSelected(item)
      } else {
        this.onTeamSelected(item);
        this.makeTeamDefault(item)
      }
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

    onDefaultTeamSelected(team) {
      this.$store.dispatch(UPDATE_DEFAULT_TEAM, {
        teamId: team.id,
        organization: this.organization,
      });
    }
  },
  components: {
    ClickableDropdown,
  },
};
</script>
