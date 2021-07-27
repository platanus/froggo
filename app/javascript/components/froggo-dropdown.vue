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
      :class="`absolute shadow z-10 ${align}-0`"
      v-if="showBody"
      @click="closeDropdown"
    >
      <slot
        name="body"
      />
    </div>
  </div>
</template>

<script>
import { mixin as clickaway } from 'vue-clickaway';

export default {
  mixins: [clickaway],
  props: {
    align: {
      type: String,
      default: 'left-0 right',
    },
  },
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
