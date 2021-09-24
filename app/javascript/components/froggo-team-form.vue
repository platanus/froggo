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
    <multiselect-froggo-teams
      v-model="selectedUsers"
      :options="users"
      track-by="id"
      @remove-from-selected-users="deleteUserFromSelectedUsers($event)"
    />
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
import froggoTeamMixin from '../mixins/froggoTeamMixin';
import MultiselectFroggoTeams from './shared/multiselect-froggo-teams.vue';

export default {
  mixins: [showMessageMixin, froggoTeamMixin],
  components: { MultiselectFroggoTeams },
  data() {
    return {
      teamName: '',
      selectedUsers: this.teamUsers,
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
    teamUsers: { type: Array, require: false, default() { return []; } },
  },
  methods: {
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
