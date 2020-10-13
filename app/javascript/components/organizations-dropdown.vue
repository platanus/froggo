<template>
  <clickable-dropdown
    :body-title="dropdownTitle"
    :no-items-message="noOrganizationsMessage"
    :items="organizations"
    :default-index="defaultOrganizationIndex"
    @item-clicked="onItemClicked"
  />
</template>

<script>
import ClickableDropdown from './clickable-dropdown';
import { PROCESS_NEW_TEAM } from '../store/action-types';
import {
  PROFILE_ORGANIZATION_SELECTED,
  PROFILE_TEAM_SELECTED,
  PROFILE_PR_INFORMATION_RECEIVED,
} from '../store/mutation-types';

export default {
  props: {
    organizations: Array,
    teams: Array,
    githubLogin: String,
  },
  data() {
    return {
      dropdownTitle: this.$t('message.profile.organizationsDropdownTitle'),
      noOrganizationsMessage: this.$t('message.profile.noOrganizations'),
    };
  },
  mounted() {
    const defaultOrganization = this.organizations[this.defaultOrganizationIndex];
    if (defaultOrganization) {
      this.selectOrganization(defaultOrganization);
    }
  },
  computed: {
    defaultOrganizationIndex() {
      if (!localStorage.mapUserToDefaultOrg) {
        return 0;
      }
      const mapUserToDefaultOrg = JSON.parse(localStorage.mapUserToDefaultOrg);
      if (!mapUserToDefaultOrg.hasOwnProperty(this.githubLogin)) {
        return 0;
      }
      const orgId = mapUserToDefaultOrg[this.githubLogin];
      const index = this.organizations.findIndex(organization => organization.id === orgId);
      if (index >= 0) {
        return index;
      }

      return 0;
    },
  },
  methods: {
    onItemClicked({ item }) {
      this.selectOrganization(item);
      this.makeOrganizationDefault(item);
    },
    selectOrganization(organization) {
      const organizationTeams = this.teams.filter(team => team.organization_id === organization.id);
      if (organizationTeams.length === 0) {
        this.$store.commit(PROFILE_ORGANIZATION_SELECTED, organization.id);
        this.$store.commit(PROFILE_TEAM_SELECTED, { teamId: null, froggoTeam: false });
        this.$store.commit(PROFILE_PR_INFORMATION_RECEIVED, { 'pull_requests_information': {} });

        return;
      }
      const defaultTeam =
          this.organizationHasDefaultTeam(organization) ?
            this.teams.filter(team => team.id === organization.default_team_id)[0] :
            organizationTeams[0];

      this.$store.dispatch(PROCESS_NEW_TEAM, {
        teamId: defaultTeam.id,
        organizationId: organization.id,
        githubUserLogin: this.githubLogin,
        froggoTeam: defaultTeam.froggo_team,
      });
      this.makeTeamDefault(defaultTeam);
    },
    makeOrganizationDefault(organization) {
      const mapUserToDefaultOrg =
        localStorage.mapUserToDefaultOrg ?
          JSON.parse(localStorage.mapUserToDefaultOrg) :
          {};
      mapUserToDefaultOrg[this.githubLogin] = organization.id;
      localStorage.mapUserToDefaultOrg = JSON.stringify(mapUserToDefaultOrg);
    },
    makeTeamDefault(team) {
      const mapUserToDefaultTeam =
        localStorage.mapUserToDefaultTeam ?
          JSON.parse(localStorage.mapUserToDefaultTeam) :
          {};
      mapUserToDefaultTeam[this.githubLogin] = team.id;
      localStorage.mapUserToDefaultTeam = JSON.stringify(mapUserToDefaultTeam);
    },
    organizationHasDefaultTeam(organization) {
      return this.teams.map(t => t.id).includes(organization.default_team_id);
    },
  },
  components: {
    ClickableDropdown,
  },
};
</script>
