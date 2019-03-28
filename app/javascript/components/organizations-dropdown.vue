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
import { PROCESS_NEW_ORGANIZATION } from '../store/action-types';
import { mapState } from 'vuex';

export default {
  props: {
    organizations: Array,
    githubLogin: String,
    teams: Array,
  },
  data() {
    return {
      dropdownTitle: this.$t('message.profile.organizationsDropdownTitle'),
      noOrganizationsMessage: this.$t('message.profile.noOrganizations'),
    };
  },
  mounted() {
    const selectedOrganization = this.organizations[this.defaultOrganizationIndex];
    if (selectedOrganization) {
      this.onOrganizationSelected(selectedOrganization);
    }
  },
  computed: {
    defaultOrganizationIndex() {
      if (!localStorage.mapUserToDefaultOrganization) {
        return 0;
      }
      const mapUserToDefaultOrganization = JSON.parse(localStorage.mapUserToDefaultOrganization);
      if (!mapUserToDefaultOrganization.hasOwnProperty(this.githubLogin)) {
        return 0;
      }
      const organizationId = mapUserToDefaultOrganization[this.githubLogin];
      const index = this.organizations.findIndex(organization => organization.id === organizationId);
      if (index >= 0) {
        return index;
      }

      return 0;
    },
  },
  methods: {
    onItemClicked({ item }) {
      this.onOrganizationSelected(item);
      this.makeOrganizationDefault(item)
    },

    onOrganizationSelected(organization) {
      this.$store.dispatch(PROCESS_NEW_ORGANIZATION, {
        organizationId: organization.id,
        githubUserLogin: this.githubLogin,
        teams: this.teams,
      });
    },

    makeOrganizationDefault(organization) {
      const mapUserToDefaultOrganization =
        localStorage.mapUserToDefaultOrganization ?
          JSON.parse(localStorage.mapUserToDefaultOrganization) :
          {};
      mapUserToDefaultOrganization[this.githubLogin] = organization.id;
      localStorage.mapUserToDefaultOrganization = JSON.stringify(mapUserToDefaultOrganization);
    },
  },
  components: {
    ClickableDropdown,
  },
};
</script>
