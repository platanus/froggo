<template>
  <div :class="containerClass">
    <profile-number
      :value="scoreThisWeek"
      text="puntaje esta semana"
    >
    </profile-number>
    <profile-number
      :value="weeklyPercentualDifference"
      :colored="true"
      unit="%"
      text="diferencia semana pasada"
    >
    </profile-number>
  </div>
</template>

<script>
import ProfileNumber from './number.vue';

const MAX_PERCENTUAL_DIFFERENCE = 999;

export default {
  props: {
    scoreThisWeek: Number,
    scoreLastWeek: Number,
    containerClass: {
      type: String,
      default: '',
    },
  },
  computed: {
    weeklyPercentualDifference() {
      if (this.scoreThisWeek === this.scoreLastWeek) {
        return 0;
      }

      return Math.min(
        MAX_PERCENTUAL_DIFFERENCE,
        // eslint-disable-next-line no-magic-numbers
        (this.scoreThisWeek - this.scoreLastWeek) / this.scoreLastWeek * 100
      );
    },
  },
  components: {
    ProfileNumber,
  },
};
</script>
