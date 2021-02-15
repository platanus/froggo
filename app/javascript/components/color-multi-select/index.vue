<template>
  <div class="select">
    <div
      class="select__btn--background select__btn--white select__btn--center"
      slot="btn"
    >
      <span
        class="select__colors"
      >
        <div
          v-for="(item, index) in items"
          :key="index"
          :class="`select__color-badge select__color-badge--${item.name}`"
          @click="colorClicked({ color: item.name })"
        >
          <div v-if="selectedColors[item.name]">
            <img
              class="select__check-icon"
              :src="require('../../../assets/images/white-check.svg').default"
            >
          </div>
          <div v-else>
            <img
              class="select__cross-icon"
              :src="require('../../../assets/images/white-x.svg').default"
            >
          </div>
        </div>
      </span>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    items: {
      type: Array,
      default() {
        return [];
      },
    },
  },
  data() {
    return {
      selectedColors: this.initialSelectedColors(),
    };
  },

  methods: {
    colorClicked(event) {
      this.selectedColors[event.color] = ! this.selectedColors[event.color];
      this.selectedColors = Object.assign({}, this.selectedColors);
      this.$emit('color-clicked', event);
    },
    initialSelectedColors() {
      const initialColors = this.items.reduce((map, color) => {
        map[color.name] = true;

        return map;
      }, {});

      return initialColors;
    },
  },
};
</script>
