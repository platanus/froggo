<template>
  <div
    class="relative"
    v-on-clickaway="closeDropdown"
  >
    <div
      class="cursor-pointer"
      @click="showBody = !showBody"
    >
      <slot name="btn" />
    </div>
    <div
      class="absolute z-10 right-0"
      v-if="showBody"
    >
      <slot
        name="body"
        :close-dropdown="closeDropdown"
      />
    </div>
  </div>
</template>

<script>
import { mixin as clickaway } from 'vue-clickaway';

export default {
  mixins: [clickaway],
  data() {
    return {
      showBody: false,
    };
  },
  methods: {
    closeDropdown() {
      this.showBody = false;
    },
  },
};
</script>
