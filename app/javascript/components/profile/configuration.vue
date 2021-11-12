<template>
  <div>
    <p class="text-md font-semibold mb-6">
      Configuración para recomendaciones
    </p>
    <div class="grid grid-cols-12 gap-4">
      <div class="col-span-6">
        <label class="text-xs">{{ $i18n.t('message.recommendations.team') }}</label>
        <dropdown-teams
          :teams="teams"
          :login="githubUser.login"
        />
      </div>
      <div class="col-span-6">
        <label class="text-xs">{{ $i18n.t('message.recommendations.time') }}</label>
        <div class="flex pt-1">
          <dropdown-timespan
            :timespans="timespans"
            :login="githubUser.login"
            class="flex-grow rounded"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>

import DropdownTeams from '../recommendations/dropdown-teams.vue';
import DropdownTimespan from '../recommendations/dropdown-timespan.vue';

export default {
  components: {
    DropdownTeams,
    DropdownTimespan,
  },
  props: {
    githubUser: {
      type: Object,
      required: true,
    },
    githubSession: {
      type: Object,
      required: true,
    },
    teams: {
      type: Array,
      default: () => {},
    },
    timespans: {
      type: Array,
      required: true,
    },
  },
};
</script>
