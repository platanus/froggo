<template>
  <div id="selector">
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
      selected: 'example',
    }
  },
  computed: {
    options() {
      let options = ['some', 'example', 'data'];
      return options;
    }
  },
  methods: {
    redirect(dashboard) {
      document.location.href = `/dashboard/${dashboard}`;
    }
  }
}
</script>
