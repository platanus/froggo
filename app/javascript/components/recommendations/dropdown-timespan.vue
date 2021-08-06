<template>
  <froggo-dropdown>
    <template #btn>
      <div class="flex items-center justify-between p-3 py-4 border rounded-l-lg">
        <div v-if="fetchingDefaultPreferences">
          {{ $i18n.t('message.recommendations.loading') }}
        </div>
        <div v-else>
          {{ selectedTimespan.value }}
        </div>
        <inline-svg
          :src="require('../../../assets/images/chevron-down.svg').default"
          class="text-black fill-current h-6 w-6 ml-2"
        />
      </div>
    </template>
    <template #body>
      <div class="bg-white w-full">
        <div class="grid grid-rows-auto gap-1 font-medium whitespace-no-wrap">
          <div
            v-for="timespan in timespans"
            :key="timespan.limit"
            class="p-4 w-64 cursor-pointer"
            @click="selectTimespan(timespan)"
          >
            {{ timespan.value }}
          </div>
        </div>
      </div>
    </template>
  </froggo-dropdown>
</template>
<script>

import { mapState } from 'vuex';

import { LOAD_RECOMMENDATIONS } from '../../store/action-types';
import { SET_FETCHING_RECOMMENDATIONS, SET_TIMESPAN } from '../../store/mutation-types';

export default {
  props: {
    timespans: {
      type: Array,
      default: () => [],
    },
    login: {
      type: String,
      required: true,
    },
  },
  computed: {
    ...mapState({
      selectedTimespanKey: state => state.preferences.timespan,
      fetchingDefaultPreferences: state => state.preferences.fetchingDefaultPreferences,
    }),
    selectedTimespan() {
      return this.timespans.find(timespan => timespan.key === this.selectedTimespanKey);
    },
  },
  methods: {
    async selectTimespan(timespan) {
      this.$store.commit(SET_TIMESPAN, timespan.key);
      this.$store.commit(SET_FETCHING_RECOMMENDATIONS, true);
      await this.$store.dispatch(LOAD_RECOMMENDATIONS, this.login);
      this.$store.commit(SET_FETCHING_RECOMMENDATIONS, false);
    },
  },
};
</script>
