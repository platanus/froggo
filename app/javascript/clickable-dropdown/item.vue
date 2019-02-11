<template>
  <div v-on:click="notifyContainer" class="select__option">{{ text }}</div>
</template>

<script>

export default {
  props: {
    text: String,
    index: Number,
  },
  methods: {
    notifyContainer() {
      this.$emit('item-clicked', this.index);
    },
  },
};
</script>

