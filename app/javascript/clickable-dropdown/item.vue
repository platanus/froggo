<template>
  <div v-on:click="notifyContainer" class="select__option">{{ item.name }}</div>
</template>

<script>

export default {
  props: {
    index: Number,
    item: Object,
  },
  methods: {
    notifyContainer() {
      this.$emit('item-clicked', {
        index: this.index,
        item: this.item,
      });
    },
  },
};
</script>

