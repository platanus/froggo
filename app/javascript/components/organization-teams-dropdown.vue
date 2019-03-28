<template>
  <teams-dropdown
    :github-login="githubLogin"
    :teams="this.organizationTeams">
  </teams-dropdown>
</template>

<script>
import TeamsDropdown from './teams-dropdown';
import { mapState } from 'vuex';

export default {
  props: {
    githubLogin: String,
  },
  components: {
    TeamsDropdown,
  },
  computed: mapState({
  	organizationTeams: state=> state.profile.organizationTeams,
  }),
};
</script>