<template>
  <div class="flex w-full p-2">
    <input
      :id="id"
      type="checkbox"
      class="hidden"
      v-model="selectedValues"
      v-bind="$attrs"
      :value="inputValue"
    >
    <label
      :for="id"
      class="self-center block w-4 h-4 mr-4 text-white duration-100 ease-in-out bg-gray-400 rounded cursor-pointer transition-color"
      :class="selectedValues.includes(inputValue) && 'bg-froggoGreen-500'"
    >
      <inline-svg
        :src="require('../../assets/images/icons/check-icon.svg').default"
        class="w-full h-full transition-opacity duration-100 ease-in-out opacity-0 fill-current"
        :class="selectedValues.includes(inputValue) && 'opacity-100'"
      />

    </label>
    <label
      v-if="label"
      :for="id"
      class="flex items-center w-full"
    >
      <img
        :src="avatar"
        class="h-10 mr-4"
      >
      <span class="text-base cursor-pointer select-none">
        {{ label }}
      </span>
      <span class="ml-auto text-sm text-gray-400 cursor-pointer select-none">
        {{ capitalizeRole }}
      </span>
    </label>
  </div>
</template>

<script>
export default {
  props: {
    id: { type: String, required: true },
    label: { type: String, default: null },
    value: { type: Array, default: null },
    inputValue: { type: Object, required: true },
    avatar: { type: String, default: null },
    role: { type: String, default: null },
  },
  computed: {
    selectedValues: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit('input', newValue);
      },
    },
    capitalizeRole() {
      if (this.role === 'admin') {
        return this.$t('message.froggoTeams.adminRole');
      }

      return this.$t('message.froggoTeams.memberRole');
    },
  },
};
</script>
