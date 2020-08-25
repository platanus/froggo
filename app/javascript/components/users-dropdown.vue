<template>
  <div>
    <clickable-dropdown
      :body-title="dropdownTitle"
      :no-items-message="noUsersMessage"
      :items="users"
      @item-clicked="onItemClicked"
    /><br>
    <div
      v-for="(user, index) in selected"
      :key="user.id"
    >
      <button @click="deleteItem(index)">
        X
      </button>
      {{ user.login }}
    </div><br>
  </div>
</template>

<script>
import ClickableDropdown from './clickable-dropdown';

export default {
  props: {
    users: {
      type: Array,
      required: true,
    },
  },
  data() {
    return {
      dropdownTitle: 'Usuarios',
      noUsersMessage: 'No se encontraron usuarios',
      selected: [],
    };
  },
  methods: {
    onItemClicked({ item }) {
      if (!this.selected.includes(item)) {
        this.selected = [...this.selected, item];
        this.$emit('UpdateSelected', this.selected);
      }
    },
    deleteItem({ index }) {
      this.selected.splice(index, 1);
    },
  },
  components: {
    ClickableDropdown,
  },
};
</script>
