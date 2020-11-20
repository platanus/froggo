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
import showMessageMixin from '../mixins/showMessageMixin';

export default {
  mixins: [showMessageMixin],
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
      selectOrganizationId: -1,
      selectedTeamId: -1,
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
    onOrganizationClick(index, id) {
      this.selectedOrganization = index;
      this.selectOrganizationId = id;
    },
    onTeamClick(index, id) {
      this.selectedTeam = index;
      this.selectedTeamId = id;
    },
    defaultLocal() {
      if (this.selectedMonth > -1) {
        localStorage.setItem('personalMonthIndex', this.selectedMonth);
      }
      const mapUserToDefaultTeam =
        localStorage.mapUserToDefaultTeam ?
          JSON.parse(localStorage.mapUserToDefaultTeam) :
          {};
      if (this.selectedOrganization > -1) {
        localStorage.setItem('personalOrgIndex', this.selectedOrganization);
        const mapUserToDefaultOrg =
          localStorage.mapUserToDefaultOrg ?
            JSON.parse(localStorage.mapUserToDefaultOrg) :
            {};
        mapUserToDefaultOrg[this.githubLogin] = this.selectOrganizationId;
        localStorage.mapUserToDefaultOrg = JSON.stringify(mapUserToDefaultOrg);
        if (this.selectedTeam === -1) {
          localStorage.setItem('personalTeamIndex', 0);
        }
      }
      if (this.selectedTeam > -1) {
        localStorage.setItem('personalTeamIndex', this.selectedTeam);
        mapUserToDefaultTeam[this.githubLogin] = this.selectedTeamId;
        localStorage.mapUserToDefaultTeam = JSON.stringify(mapUserToDefaultTeam);
      }
      this.showMessage(this.$t('message.settings.successfullyDefaulted'));
    },
  },
};
</script>
