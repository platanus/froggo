<template>
  <clickable-dropdown
    :body-title="dropdownTitle"
    :no-items-message="noTeamsMessage"
    :items="teams"
    @item-clicked="computeScore"
  >
  </clickable-dropdown>
</template>

<script>

import { mapActions } from 'vuex';

export default {
  props: {
    teams: Array,
  },
  data() {
    return {
      dropdownTitle: this.$t('message.profile.teamsDropdownTitle'),
      noTeamsMessage: this.$t('message.profile.noTeams')
    };
  },
  methods: {
    ...mapActions([
      'computeScore',
    ])
  },
}
</script>
