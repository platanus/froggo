<template>
  <div class="froggo-teams-show">
    <div class="froggo-teams-show__name">
      {{ froggoTeam.name }}
    </div>
    <div class="froggo-teams-show__members">
      <div class="froggo-teams-show__member-title">
        Miembros:
      </div>
      <a
        class="froggo-teams-show__member"
        v-for="user in froggoTeamMembers"
        :key="user.id"
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
    </div>
    <div>
      <button @click="editFroggoTeam">
        Editar Equipo
      </button>
      <button @click="deleteFroggoTeam">
        Eliminar Equipo
      </button>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {

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
  },
  methods: {
    editFroggoTeam() {
      return;
    },
    deleteFroggoTeam() {
      const response = confirm('Estás seguro de querer borrar el equipo ?');
      if (response) {
        axios.delete(`/api/froggo_teams/${this.froggoTeam.id}`)
          .then(() => { window.location.href = `/github_users/${this.userId}/froggo_teams`; });
      }
    },
  },
};
</script>

