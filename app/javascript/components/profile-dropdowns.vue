<template>
  <div>
    <div class="profile-header__dropdowns">
      <organizations-dropdown
        :github-login="githubLogin"
        :organizations="organizations"
        :teams="teams"
        @organization-clicked="onOrganizationClick"
      />
    </div>
    <div class="profile-header__dropdowns">
      <teams-dropdown
        :github-login="githubLogin"
        :teams="selectedOrganizationTeams"
        @team-clicked="onTeamClick"
      />
    </div>
    <div class="profile-header__dropdowns">
      <timespan-dropdown
        :github-login="githubLogin"
        :months-options="monthsOptions"
        @month-clicked="onMonthClick"
      />
    </div>
    <button
      class="card-pr__button-color"
      @click="defaultLocal()"
    >
      {{ $t("message.settings.defaultOption") }}
    </button>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import OrganizationsDropdown from './organizations-dropdown';
import TeamsDropdown from './teams-dropdown';
import TimespanDropdown from './timespan-dropdown';

export default {
  props: {
    teams: {
      type: Array,
      required: true,
    },
    githubLogin: {
      type: String,
      required: true,
    },
    organizations: {
      type: Array,
      required: true,
    },
    monthsOptions: {
      type: Array,
      required: true,
    },
  },
  data() {
    return {
      selectedMonth: -1,
      selectedOrganization: -1,
      selectedTeam: -1,
    };
  },
  components: {
    OrganizationsDropdown,
    TeamsDropdown,
    TimespanDropdown,
  },
  computed: {
    selectedOrganizationTeams() {
      return this.teams.filter(team => team.organization_id === this.selectedOrganizationId);
    },
    ...mapState({
      selectedOrganizationId: state => state.profile.selectedOrganizationId,
    }),
  },
  methods: {
    onMonthClick(index) {
      this.selectedMonth = index;
    },
    onOrganizationClick(index) {
      this.selectedOrganization = index;
    },
    onTeamClick(index) {
      this.selectedTeam = index;
    },
    defaultLocal() {
      if (this.selectedMonth > -1) {
        localStorage.setItem('monthCookieId', this.selectedMonth);
      }
      if (this.selectedOrganization > -1) {
        localStorage.setItem('organizationCookieId', this.selectedOrganization);
        if (this.selectedTeam === -1) {
          localStorage.setItem('teamCookieId', 0);
        }
      }
      if (this.selectedTeam > -1) {
        localStorage.setItem('teamCookieId', this.selectedTeam);
      }
    },
  },
};
</script>
