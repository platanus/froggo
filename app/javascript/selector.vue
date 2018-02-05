<template>
<div>
  <select v-model="selected">
    <option v-for="option in options" :value="option" :key="option">
      {{ option }}
    </option>
  </select>
  <button v-on:click="redirect(selected)">{{ $parent.$t("message.selector.button") }}</button>
</div>
</template>

<script>
export default {
  data: function () {
    return {
      selected: null,
    }
  },
  props: ['options'],
  methods: {
    redirect(dashboard) {
      document.location.href = `/organizations/${dashboard}`;
    }
  },
}
</script>
