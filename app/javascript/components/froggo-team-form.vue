<template>
  <div>
    <span>Nombre del equipo:</span><br><br>
    <input
      type="text"
      v-model="teamName"
    ><br><br>
    <span>Agregar miembro:</span><br><br>
    <users-dropdown
      :users="users"
      @UpdateSelected="updateSelected"
    />
    <div>
      <button @click="submitFroggoTeam()">
        Crear Grupo
      </button>
    </div>
  </div>
</template>

<script>
import UsersDropdown from './users-dropdown';
import { CREATE_NEW_FROGGO_TEAM } from '../store/action-types';

export default {
  data() {
    return {
      teamName: '',
      selected: [],
    };
  },
  props: {
    users: {
      type: Array,
      required: true,
    },
    organization: {
      type: Object,
      required: true,
    },
  },
  methods: {
    updateSelected(selectedUsers) {
      this.selected = selectedUsers;
    },
    submitFroggoTeam() {
      this.$store.dispatch(CREATE_NEW_FROGGO_TEAM, {
        name: this.teamName,
        organizationId: this.organization.id,
        users: this.selected,
      });
    },
  },
  components: {
    UsersDropdown,
  },
};
</script>
