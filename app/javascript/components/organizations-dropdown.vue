<template>
  <clickable-dropdown
    :body-title="dropdownTitle"
    :no-items-message="noOrganizationsMessage"
    :items="organizations"
    :default-index="defaultOrganizationIndex"
    @item-clicked="onItemClicked"
  >
  </clickable-dropdown>
</template>

<script>
import ClickableDropdown from './clickable-dropdown';
import { PROCESS_NEW_TEAM } from '../store/action-types';

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
      if (this.organizationHasDefaultTeam(organization)) {
        const defaultTeam = this.teams.filter(team => team.id === organization.default_team_id);
        this.$store.dispatch(PROCESS_NEW_TEAM, {
          teamId: organization.default_team_id,
          organizationId: organization.id,
          githubUserLogin: this.githubLogin,
          froggoTeam: defaultTeam[0].froggo_team,
        });
      }
    },
    makeOrganizationDefault(organization) {
      const mapUserToDefaultOrg =
        localStorage.mapUserToDefaultOrg ?
          JSON.parse(localStorage.mapUserToDefaultOrg) :
          {};
      mapUserToDefaultOrg[this.githubLogin] = organization.id;
      localStorage.mapUserToDefaultOrg = JSON.stringify(mapUserToDefaultOrg);
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
