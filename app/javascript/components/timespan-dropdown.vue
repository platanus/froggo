<template>
  <clickable-dropdown
    :body-title="dropdownTitle"
    :items="monthsOptions"
    :default-index="getCookie || 0"
    @item-clicked="onItemClick"
  />
</template>

<script>
import ClickableDropdown from './clickable-dropdown';
import {
  COMPUTE_RECOMMENDATIONS,
  COMPUTE_PROFILE_PR_INFORMATION,
} from '../store/action-types';

export default {
  props: {
    monthsOptions: {
      type: Array,
      default() {
        return [];
      },
    },
    githubLogin: {
      type: String,
      default: '',
    },
  },
  data() {
    return {
      dropdownTitle: this.$t('message.profile.timespanDropdownTitle'),
    };
  },
  methods: {
    onItemClick({ item, index }) {
      this.selectTimespan(item.limit);
      this.$emit('month-clicked', index);
    },
    selectTimespan(limit) {
      this.$store.dispatch(COMPUTE_RECOMMENDATIONS, {
        teamId: this.$store.state.profile.selectedTeamId,
        githubUserLogin: this.githubLogin,
        monthLimit: limit,
        froggoTeam: this.$store.state.profile.isSelectedFroggoTeam,
      });
      this.$store.dispatch(COMPUTE_PROFILE_PR_INFORMATION, {
        githubUserLogin: this.githubLogin,
        monthLimit: limit,
      });
    },
  },
  computed: {
    getCookie() {
      return parseInt(localStorage.getItem('personalMonthIndex'), 10);
    },
  },
  components: {
    ClickableDropdown,
  },
};
</script>
