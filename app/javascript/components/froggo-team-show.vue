<template>
  <div class="froggo-teams-show">
    <div class="froggo-teams-show__name">
      <div class="froggo-teams-show__name-container">
        {{ froggoTeam.name }}
      </div>
      <button @click="editFroggoTeamName">
        {{ $t("message.froggoTeams.editName") }}
      </button>
    </div>
    <div v-if="editName">
      <input
        type="text"
        v-model="newName"
      >
      <button @click="submitName()">
        {{ $t("message.froggoTeams.saveName") }}
      </button>
    </div>
    <div class="froggo-teams-show__members">
      <div class="froggo-teams-show__member-title">
        {{ $t("message.froggoTeams.members") }}
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
          {{ $t("message.froggoTeams.deleteFromTeam") }}
        </button>
      </div>
      <div class="froggo-teams-show__member-title">
        {{ $t("message.froggoTeams.addMember") }}
      </div>
      <div class="froggo-teams-show__dropdown">
        <users-dropdown
          :users="organizationMembers"
          @UpdateSelected="updateSelected"
        />
      </div>
      <div class="froggo-teams-show__member-title">
        {{ $t("message.froggoTeams.membersToDelete") }}
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
        {{ $t("message.froggoTeams.saveTeam") }}
      </button>
      <button @click="deleteFroggoTeam">
        {{ $t("message.froggoTeams.deleteTeam") }}
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

