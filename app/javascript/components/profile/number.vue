<template>
  <div class="colored-number">
    <div
      class="colored-number__value"
      :class="colored
        ? {
            'colored-number__value--positive': value > 0,
            'colored-number__value--zero': value === 0,
            'colored-number__value--negative': value < 0,
          }
        : false
      "
    >
      {{ value.toFixed(1) }} {{ unit }}
    </div>
    <div class="colored-number__text">
      {{ text }}
    </div>
  </div>
</template>

<script>
export default {
  props: {
    value: Number,
    text: String,
    unit: {
      type: String,
      default: '',
    },
    colored: {
      type: Boolean,
      default: false,
    },
  },
};
</script>
