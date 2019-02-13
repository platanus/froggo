<template>
  <clickable-dropdown
    :body-title="dropdownTitle"
    :no-items-message="noTeamsMessage"
    :items="teams"
    @item-clicked="teamSelected"
  >
  </clickable-dropdown>
</template>

<script>
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
    teamSelected(event) {
      // TODO:
    }
  },
}
</script>
