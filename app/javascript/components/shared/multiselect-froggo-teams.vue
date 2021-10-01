<template>
  <multiselect
    class="mb-4"
    placeholder="Escoge a los miembros del equipo"
    select-label="Seleccionar"
    selected-label="Seleccionado"
    deselect-label="Sacar"
    :hide-selected="true"
    :multiple="true"
    :close-on-select="false"
    :clear-on-select="false"
    :preserve-search="true"
    :searchable="true"
    :value="value"
    :options="options"
    :track-by="trackBy"
    :custom-label="nameOrLogin"
    @input="(newValue) => this.$emit('input', newValue)"
  >
    <template
      slot="tag"
      slot-scope="props"
    >
      <div class="inline-block">
        <div class="flex items-center p-2 mb-2 mr-2 text-white bg-blue-900 border rounded-full">
          <img
            :src="props.option.avatarUrl"
            class="w-5 h-5 mr-2 rounded-full"
          >
          <span class="mr-2">{{ nameOrLogin(props.option) }}</span>
          <img
            :src="require('../../../assets/images/close.svg').default"
            class="w-5 h-5 rounded-full cursor-pointer"
            @click="deleteUserFromSelectedUsers(props.option)"
          >
        </div>
      </div>
    </template>
  </multiselect>
</template>
<script>
export default {
  props: {
    value: { type: [Array, Object, String], default() { return {}; } },
    options: { type: Array, default() { return []; } },
    label: { type: String, default: null },
    trackBy: { type: String, default: null },
  },
  data() {
    return {
      internalValue: this.value,
    };
  },
  methods: {
    nameOrLogin(object) {
      return object.name || object.login;
    },
    deleteUserFromSelectedUsers(userToDelete) {
      this.$emit('remove-from-selected-users', userToDelete);
    },
  },
};
</script>
