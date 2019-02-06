<template>
  <div v-on:click="notifyContainer" class="select__option">{{ text }}</div>
</template>

<script>

/*
 * Represents each item within ClickableDropdown.
 * Emits `item-clicked` when an item is clicked`
 */
export default {
  props: {
    text: String,
    index: Number,
  },
  methods: {
    notifyContainer: function() {
      this.$emit('item-clicked', this.index);
    }
  }
};
</script>

