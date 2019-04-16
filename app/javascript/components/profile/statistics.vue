<template>
  <div :class="containerClass">
    <profile-number
      :value="obedientCount"
      text="Recomendaciones seguidas"
    >
    </profile-number>
    <profile-number
      :value="indifferentCount"
      text="Recomendaciones ignoradas"
    >
    </profile-number>
    <profile-number
      :value="rebelCount"
      text="Recomendaciones no seguidas"
    >
    </profile-number>
  </div>
</template>

<script>
import ProfileNumber from './number.vue';

export default {
  props: {
    obedientCount: Number,
    indifferentCount: Number,
    rebelCount: Number,
    notDefinedCount: Number,
    containerClass: {
      type: String,
      default: '',
    },
  },
  components: {
    ProfileNumber,
  },
};
</script>
