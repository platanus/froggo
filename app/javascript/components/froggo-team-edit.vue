<template>
  <div class="flex-col felx">
    <div class="flex flex-col w-full p-8 border rounded-md">
      <p class="mb-2">
        {{ $t('message.froggoTeams.editTeam') }}
      </p>
      <input
        class="p-2 mb-4 border rounded-md"
        type="text"
        v-model="newTeamName"
        placeholder="Nombre"
      >
      <p class="mb-2">
        {{ $t('message.froggoTeams.members') }}
      </p>
      <multiselect-froggo-teams
        v-model="selectedUsers"
        :options="organizationMembers"
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
        @click="saveFroggoTeam()"
      >
        {{ $t("message.froggoTeams.updateButton") }}
      </button>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import {
  UPDATE_FROGGO_TEAM,
  DELETE_FROGGO_TEAM,
} from '../store/action-types';
import {
  TEAM_NAME,
  LOAD_MEMBERS,
} from '../store/mutation-types';
import showMessageMixin from '../mixins/showMessageMixin';
import froggoTeamMixin from '../mixins/froggoTeamMixin';
import MultiselectFroggoTeams from './shared/multiselect-froggo-teams.vue';

export default {
  mixins: [showMessageMixin, froggoTeamMixin],
  components: {
    MultiselectFroggoTeams,
  },
  beforeMount() {
    this.$store.commit(TEAM_NAME, this.froggoTeam.name);
    this.$store.commit(LOAD_MEMBERS, { members: this.froggoTeamMembers,
      possibleMembers: this.organizationMembers });
  },
  data() {
    return {
      newTeamName: this.froggoTeam.name,
      selectedUsers: this.froggoTeamMembers,
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
    organization: { type: Object, default() { return {}; } },
  },
  methods: {
    getParams() {
      const froggoTeamMembers = this.froggoTeamMembers;
      const selectedUsers = this.selectedUsers;
      const newMembers = this.selectedUsers.filter((user) => !froggoTeamMembers.includes(user));
      const oldMembers = this.froggoTeamMembers.filter((user) => !selectedUsers.includes(user));
      let params = {
        newMembersIds: newMembers.map(user => user.id),
        oldMembersIds: oldMembers.map(user => user.id),
        id: this.froggoTeam.id,
      };
      if (this.teamNameChanged) {
        params = { ...params, name: this.newTeamName };
      }

      return params;
    },
    saveFroggoTeam() {
      this.$store.dispatch(UPDATE_FROGGO_TEAM, this.getParams())
        .then(() => {
          this.showMessage(this.$i18n.t('message.froggoTeams.successfullySavedChanges'));
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
  computed: {
    teamNameChanged() {
      return this.newTeamName !== this.froggoTeam.name;
    },
    membersCounter() {
      return this.currentMembers.length;
    },
    ...mapState({
      teamName: state => state.froggoTeam.teamName,
      currentMembers: state => state.froggoTeam.currentMembers,
      possibleMembers: state => state.froggoTeam.possibleMembers,
    }),
  },
};
</script>
