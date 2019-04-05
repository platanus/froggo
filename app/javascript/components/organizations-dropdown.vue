<template>
  <clickable-dropdown
    :body-title="dropdownTitle"
    :no-items-message="noOrganizationsMessage"
    :items="organizationsWithName"
    :default-index="defaultOrganizationIndex"
    @item-clicked="onItemClicked"
  >
  </clickable-dropdown>
</template>

<script>
import ClickableDropdown from './clickable-dropdown';
import { PROCESS_NEW_ORGANIZATION } from '../store/action-types';
import FroggoLocalStorage from '../helpers/local-storage';

export default {
  props: {
    organizations: Array,
    githubLogin: String,
    teams: Array,
  },
  data() {
    const namedOrganizations = this.organizations;
    namedOrganizations.forEach((organization) =>
      (organization.name = organization.login));

    return {
      dropdownTitle: this.$t('message.profile.organizationsDropdownTitle'),
      noOrganizationsMessage: this.$t('message.profile.noOrganizations'),
      organizationsWithName: namedOrganizations,
    };
  },
  computed: {
    defaultOrganizationIndex() {
      const index = this.getDefaultOrganizationIndex();
      const selectedOrganization = this.organizations[index];
      if (selectedOrganization) {
        this.onOrganizationSelected(selectedOrganization);
      }

      return index;
    },
  },
  methods: {
    getDefaultOrganizationIndex() {
      return FroggoLocalStorage.get(
        'mapUserToDefaultOrganization',
        this.githubLogin,
        this.organizations
      );
    },

    onItemClicked({ item }) {
      this.onOrganizationSelected(item);
      this.makeOrganizationDefault(item);
    },

    onOrganizationSelected(organization) {
      this.$store.dispatch(PROCESS_NEW_ORGANIZATION, {
        organizationId: organization.id,
        teams: this.teams,
      });
    },

    makeOrganizationDefault(organization) {
      FroggoLocalStorage.set(
        'mapUserToDefaultOrganization',
        this.githubLogin,
        organization.id
      );
    },
  },
  components: {
    ClickableDropdown,
  },
};
</script>
