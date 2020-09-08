<template>
  <div class="profile-statistics">
    <div
      class="colored-number centered"
      v-for="metric in metricsSummary"
      :key="metric.id"
    >
      <div class="colored-number__value">
        {{ metric.value }}
      </div>
      <div class="colored-number__text">
        {{ metric.textTop }} <br> {{ metric.textBottom }}
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    metricsSummary: {
      default: () => [],
      type: Array,
    },
  },
};
</script>
