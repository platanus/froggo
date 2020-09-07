<template>
  <div>
    <div>
      <organizations-dropdown
        :github-login="githubLogin"
        :organizations="organizations"
        :teams="teams"
      />
    </div>
    <div>
      <teams-dropdown
        :github-login="githubLogin"
        :teams="teams"
      />
    </div>
    <div>
      <timespan-dropdown
        :github-login="githubLogin"
        :months-options="monthsOptions"
      />
    </div>
  </div>
</template>

<script>
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
};
</script>
