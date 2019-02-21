<template>
  <div class="profile__number-container">
    <div
      class="profile__number"
      :class="colored
        ? {
            'profile__number--positive': value > 0,
            'profile__number--zero': value === 0,
            'profile__number--negative': value < 0,
          }
        : false
      "
    >
      {{ value.toFixed(1) }} {{ unit }}
    </div>
    <div class="profile__text">
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
}
</script>
