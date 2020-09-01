<template>
  <div class="froggo-teams-show">
    <div class="froggo-teams-show__name">
      <div class="froggo-teams-show__name-container">
        {{ froggoTeam.name }}
      </div>
      <button @click="editFroggoTeamName">
        Editar Nombre
      </button>
    </div>
    <div v-if="editName">
      <input
        type="text"
        v-model="newName"
      >
      <button @click="submitName()">
        Guardar Nombre
      </button>
    </div>
    <div class="froggo-teams-show__members">
      <div class="froggo-teams-show__member-title">
        Miembros:
      </div>
      <div
        class="froggo-teams-show__member-container"
        v-for="user in froggoTeamMembers"
        :key="user.id"
      >
        <a
          class="froggo-teams-show__member"
          :href="`/users/${user.id}`"
        >
          <img
            class="froggo-teams-show__picture"
            :src="user.avatar_url"
          >
          <div class="froggo-teams-show__username">
            {{ user.login }}
          </div>
        </a>
        <button @click="deleteMember(user)">
          Quitar del equipo
        </button>
      </div>
      <div class="froggo-teams-show__member-title">
        Añadir miembros:
      </div>
      <div class="froggo-teams-show__dropdown">
        <users-dropdown
          :users="organizationMembers"
          @UpdateSelected="updateSelected"
        />
      </div>
      <div class="froggo-teams-show__member-title">
        Miembros a eliminar:
      </div>
      <div
        v-for="user in oldUsers"
        :key="user.login"
      >
        {{ user.login }}
      </div>
    </div>
    <div>
      <button @click="saveFroggoTeam">
        Guardar Equipo
      </button>
      <button @click="deleteFroggoTeam">
        Eliminar Equipo
      </button>
    </div>
  </div>
</template>

<script>
import {
  UPDATE_FROGGO_TEAM,
  DELETE_FROGGO_TEAM,
} from '../store/action-types';
import UsersDropdown from './users-dropdown';

export default {
  data() {
    return {
      editName: false,
      newName: '',
      newUsers: [],
      oldUsers: [],
    };
  },
  props: {
    userId: {
      type: Number,
      required: true,
    },
    froggoTeam: {
      type: Object,
      required: true,
    },
    froggoTeamMembers: {
      type: Array,
      required: true,
    },
    organizationMembers: {
      type: Array,
      required: true,
    },
  },
  methods: {
    editFroggoTeamName() {
      this.editName = !this.editName;
    },
    submitName() {
      this.$store.dispatch(UPDATE_FROGGO_TEAM, {
        name: this.newName,
        id: this.froggoTeam.id,
      })
        .then(() => {
          window.location.href = `/froggo_teams/${this.froggoTeam.id}`;
        });
    },
    updateSelected(selectedUsers) {
      this.newUsers = selectedUsers;
    },
    deleteMember(user) {
      this.oldUsers = [...this.oldUsers, user];
    },
    saveFroggoTeam() {
      this.$store.dispatch(UPDATE_FROGGO_TEAM, {
        newMembersIds: this.newUsers.map(user => user.id),
        oldMembersIds: this.oldUsers.map(user => user.id),
        id: this.froggoTeam.id,
      })
        .then(() => {
          window.location.href = `/froggo_teams/${this.froggoTeam.id}`;
        });
    },
    deleteFroggoTeam() {
      this.$store.dispatch(DELETE_FROGGO_TEAM, {
        id: this.froggoTeam.id,
      })
        .then(response => {
          if (response) {
            window.location.href = `/github_users/${this.userId}/froggo_teams`;
          }
        });
    },
  },
  components: {
    UsersDropdown,
  },
};
</script>

