<template>
  <div class="flex flex-col w-full p-8 border rounded-md">
    <p class="mb-2">
      {{ $t('message.froggoTeams.newTeam') }}
    </p>
    <input
      class="p-2 mb-4 border rounded-md"
      type="text"
      v-model="teamName"
      placeholder="Nombre"
    >
    <p class="mb-2">
      {{ $t('message.froggoTeams.members') }}
    </p>
    <multiselect
      class="mb-4"
      placeholder="Escoge a los miembros del equipo"
      select-label="Seleccionar"
      selected-label="Seleccionado"
      deselect-label="Sacar"
      hide-selected="true"
      v-model="selectedUsers"
      :options="users"
      :custom-label="nameOrLogin"
      :multiple="true"
      :close-on-select="false"
      :clear-on-select="false"
      :preserve-search="true"
      :searchable="true"
      track-by="id"
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
              :src="require('../../assets/images/close.svg').default"
              class="w-5 h-5 rounded-full cursor-pointer"
              @click="deleteUserFromSelectedUsers(props.option)"
            >
          </div>
        </div>
      </template>
    </multiselect>
    <button
      class="self-end w-48 p-2 mb-4 border rounded-md focus:outline-none hover:bg-gray-300"
      @click="cleanSelectedUsers"
    >
      {{ $t("message.froggoTeams.cleanSelection") }}
    </button>
    <button
      class="self-end w-48 p-2 text-white bg-green-600 border rounded-md focus:outline-none hover:bg-green-700"
      @click="submitFroggoTeam()"
    >
      {{ $t("message.froggoTeams.createButton") }}
    </button>
  </div>
</template>

<script>
import { CREATE_NEW_FROGGO_TEAM } from '../store/action-types';
import showMessageMixin from '../mixins/showMessageMixin';

export default {
  mixins: [showMessageMixin],
  data() {
    return {
      teamName: '',
      selectedUsers: [this.users[0]],
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
    deleteUserFromSelectedUsers(userToDelete) {
      this.selectedUsers = this.selectedUsers.filter(user => user.id !== userToDelete.id);
    },
    cleanSelectedUsers() {
      this.selectedUsers = [];
    },
    nameOrLogin(object) {
      return object.name || object.login;
    },
    updateSelected(selectedUsers) {
      this.selected = selectedUsers;
    },
    submitFroggoTeam() {
      this.$store.dispatch(CREATE_NEW_FROGGO_TEAM, {
        name: this.teamName,
        organizationId: this.organization.id,
        userIds: this.selectedUsers.map(user => user.id),
      })
        .then(response => {
          this.showMessage(this.$t('message.froggoTeams.successfullyCreatedTeam'));
          window.location.href = `/froggo_teams/${response.data.data.id}`;
        })
        .catch(error => {
          const unauthorizedStatus = 401;
          const message =
            error.response.status === unauthorizedStatus ?
              this.$t('message.error.unauthorized') :
              this.$t('message.error.existentName');
          this.showMessage(message);
        });
    },
  },
};
</script>
