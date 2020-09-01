<template>
  <div class="froggo-teams-form">
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
      <div
        class="froggo-teams-form__button"
        @click="submitFroggoTeam()"
      >
        Crear Grupo
      </div>
    </div>
  </div>
</template>

<script>
import UsersDropdown from './users-dropdown';
import { CREATE_NEW_FROGGO_TEAM } from '../store/action-types';
import showMessageMixin from '../mixins/showMessageMixin';

export default {
  mixins: [showMessageMixin],
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
        userIds: this.selected.map(user => user.id),
      })
        .then(response => {
          this.showMessage('se creó el grupo correctamente');
          window.location.href = `/froggo_teams/${response.data.id}`;
        })
        .catch(() => {
          this.showMessage('no se pudo crear el grupo');
        });
    },
  },
  components: {
    UsersDropdown,
  },
};
</script>
