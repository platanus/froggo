<template>
  <div>
    <div class="profile-header__dropdowns">
      <organizations-dropdown
        :github-login="githubLogin"
        :organizations="organizations"
        :teams="teams"
      />
    </div>
    <div class="profile-header__dropdowns">
      <teams-dropdown
        :github-login="githubLogin"
        :teams="selectedOrganizationTeams"
      />
    </div>
    <div class="profile-header__dropdowns">
      <timespan-dropdown
        :github-login="githubLogin"
        :months-options="monthsOptions"
      />
    </div>
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
};
</script>
