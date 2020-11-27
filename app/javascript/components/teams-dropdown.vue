<template>
  <clickable-dropdown
    :body-title="dropdownTitle"
    :no-items-message="noTeamsMessage"
    :items="teams"
    :default-index="getCookie || 0"
    @item-clicked="onItemClicked"
  />
</template>

<script>
import ClickableDropdown from './clickable-dropdown';
import { PROCESS_NEW_TEAM, UPDATE_DEFAULT_TEAM } from '../store/action-types';

export default {
  props: {
    teams: Array,
    githubLogin: String,
    organization: Object,
    adminMode: {
      type: Boolean,
      default: false,
    },
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
      monthSeparationDropdown: 3,
    };
  },

  watch: {
    defaultTeamIndex(newValue) {
      if (!this.adminMode) {
        const selectedTeam = this.teams[newValue];
        if (selectedTeam) {
          this.onTeamSelected(selectedTeam);
        }
      }
    },
  },

  computed: {
    defaultTeamIndex() {
      if (this.adminMode) {
        const defaultTeamId = this.organization.default_team_id;

        return defaultTeamId ? this.teams.findIndex(team => team.id === defaultTeamId) : -1;
      }
      if (!localStorage.mapUserToDefaultTeam) return 0;
      const mapUserToDefaultTeam = JSON.parse(localStorage.mapUserToDefaultTeam);
      if (!mapUserToDefaultTeam.hasOwnProperty(this.githubLogin)) return 0;
      const teamId = mapUserToDefaultTeam[this.githubLogin];
      const index = this.teams.findIndex(team => team.id === teamId);
      if (index >= 0) return index;

      return 0;
    },
    getCookie() {
      return parseInt(localStorage.getItem('personalTeamIndex'), 10);
    },
  },
  methods: {
    onItemClicked({ index, item }) {
      if (this.adminMode) {
        this.onDefaultTeamSelected(item);
      } else {
        this.onTeamSelected(item);
        this.makeTeamDefault(item);
      }
      this.$emit('team-clicked', index, item.id);
    },

    onTeamSelected(team) {
      const monthPersonalLimit =
        (parseInt(localStorage.getItem('personalMonthIndex'), 10) * this.monthSeparationDropdown) || 1;
      this.$store.dispatch(PROCESS_NEW_TEAM, {
        teamId: team.id,
        organizationId: team.organization_id,
        githubUserLogin: this.githubLogin,
        froggoTeam: team.froggo_team,
        monthLimit: monthPersonalLimit,
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
        froggoTeam: team.froggo_team,
      });
    },
  },
  components: {
    ClickableDropdown,
  },
};
</script>
