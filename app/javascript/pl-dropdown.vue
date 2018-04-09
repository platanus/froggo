<template>
  <div class="pl-dropdown" v-on-clickaway="closeDropdown">
    <div class="pl-dropdown__btn" @click="showBody = !showBody">
      <slot name="btn">
        Open me
      </slot>
    </div>
    <div class="pl-dropdown__body" v-if="showBody">
      <slot name="body" :close-dropdown="closeDropdown">
        Dropdown body
      </slot>
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
      }
    },
    methods: {
      closeDropdown() {
        this.showBody = false;
      }
    }
  }
</script>
