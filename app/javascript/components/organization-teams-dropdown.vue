<template>
  <teams-dropdown
    :github-login="githubLogin"
    :teams="this.organizationTeams">
  </teams-dropdown>
</template>

<script>
import { mapState } from 'vuex';
import TeamsDropdown from './teams-dropdown';

export default {
  props: {
    githubLogin: String,
  },
  components: {
    TeamsDropdown,
  },
  computed: mapState({
    organizationTeams: state => state.profile.organizationTeams,
  }),
};
</script>
