<template>
  <div class="grid grid-flow-rows px-20">
    <div
      class="col-span-12"
      v-if="!noOrganizations"
    >
      <div class="grid grid-cols-12 gap-4 pt-5">
        <div class="col-span-6">
          <label class="text-xs">{{ $i18n.t('message.recommendations.team') }}</label>
          <dropdown-teams
            :login="user.login"
            :teams="teams"
          />
        </div>
        <div class="col-span-6">
          <label class="text-xs">{{ $i18n.t('message.recommendations.time') }}</label>
          <div class="flex pt-1">
            <dropdown-timespan
              :timespans="timespans"
              :login="user.login"
              class="flex-grow"
            />
            <default-preferences
              :user="user"
            />
          </div>
        </div>
      </div>
      <div class="mt-3">
        <recommendations-team
          :pull-requests="pullRequests"
        />
      </div>
    </div>
    <div
      v-else
      class="rounded border p-3 text-sm text-black text-opacity-25 text-center mt-5"
    >
      {{ $i18n.t('message.recommendations.noOrganizations') }}
    </div>
  </div>
</template>
<script>

import { mapState } from 'vuex';

import DropdownTeams from './dropdown-teams.vue';
import DropdownTimespan from './dropdown-timespan.vue';
import RecommendationsTeam from './team.vue';
import DefaultPreferences from './default-preferences.vue';

export default {
  components: {
    RecommendationsTeam,
    DropdownTeams,
    DropdownTimespan,
    DefaultPreferences,
  },
  props: {
    teams: {
      type: Array,
      default: () => {},
    },
    timespans: {
      type: Array,
      required: true,
    },
    user: {
      type: Object,
      required: true,
    },
    pullRequests: {
      type: Array,
      default: () => [],
    },
  },
  computed: mapState({
    noOrganizations: state => state.recommendations.noOrganizations,
  }),
};
</script>

