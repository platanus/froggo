<template>
  <div class="bg-blue-900 h-full text-white">
    <div class="grid grid-flow-row">
      <div class="p-3 text-gray-500">
        <a
          class="flex items-center"
        >
          <inline-svg
            :src="require('assets/images/pull-request.svg').default"
            class="fill-current h-5 w-5 my-3 ml-4 mr-2"
          />
          <span>{{ $i18n.t('message.global.sidebar.recommendations') }}</span>
        </a>
      </div>
      <div :class="`p-3 ${hightlight(teamsPath)}`">
        <a
          :href="teamsPath"
          class="flex items-center"
        >
          <inline-svg
            :src="require('assets/images/groups.svg').default"
            class="fill-current h-5 w-5 my-3 ml-4 mr-2"
          />
          <span>{{ $i18n.t('message.global.sidebar.teams') }}</span>
        </a>
      </div>
      <div :class="`p-3 ${hightlight(feedPath)}`">
        <a
          :href="feedPath"
          class="flex items-center"
        >
          <inline-svg
            :src="require('assets/images/saved-search.svg').default"
            class="fill-current h-5 w-5 my-3 ml-4 mr-2"
          />
          <span>{{ $i18n.t('message.global.sidebar.feed') }}</span>
        </a>
      </div>
      <div class="p-3 text-gray-500">
        <a
          class="flex items-center"
        >
          <inline-svg
            :src="require('assets/images/auto-graph.svg').default"
            class="fill-current h-5 w-5 my-3 ml-4 mr-2"
          />
          <span>{{ $i18n.t('message.global.sidebar.metrics') }}</span>
        </a>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    feedPath: {
      type: String,
      default: '/',
    },
    teamsPath: {
      type: String,
      default: '/',
    },
    metricsPath: {
      type: String,
      default: '/',
    },
  },
  methods: {
    hightlight(path) {
      if (path === window.location.pathname) {
        return 'bg-blue-800';
      }

      return '';
    },
  },
};
</script>
