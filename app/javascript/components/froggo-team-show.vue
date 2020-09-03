<template>
  <div class="froggo-teams-show">
    <div class="froggo-teams-show__name">
      <div class="froggo-teams-show__name-container">
        {{ teamName }}
      </div>
      <div
        class="froggo-teams-show__white-button"
        @click="editFroggoTeamName"
      >
        {{ $t("message.froggoTeams.editName") }}
      </div>
    </div>
    <div
      class="froggo-teams-show__edit-name-section"
      v-if="editName"
    >
      <input
        type="text"
        v-model="newName"
      >
      <div
        class="froggo-teams-show__gray-button"
        @click="submitName()"
      >
        {{ $t("message.froggoTeams.saveName") }}
      </div>
    </div>
    <div class="froggo-teams-show__members">
      <div class="froggo-teams-show__member-title">
        {{ $t("message.froggoTeams.members") }}
      </div>
      <div
        class="froggo-teams-show__member-container"
        v-for="(user, index) in currentMembers"
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
        <div
          class="froggo-teams-show__gray-button"
          @click="removeMember(user, index)"
        >
          {{ $t("message.froggoTeams.deleteFromTeam") }}
        </div>
      </div>
      <div class="froggo-teams-show__member-title">
        {{ $t("message.froggoTeams.addMember") }}
      </div>
      <div class="froggo-teams-show__dropdown">
        <clickable-dropdown
          :body-title="dropdownTitle"
          :no-items-message="noUsersMessage"
          :items="possibleMembers"
          @item-clicked="onItemClicked"
        />
      </div>
    </div>
    <div class="froggo-teams-show__end-section">
      <div
        class="froggo-teams-show__gray-button"
        @click="saveFroggoTeam"
      >
        {{ $t("message.froggoTeams.saveTeam") }}
      </div>
      <div
        class="froggo-teams-show__gray-button"
        @click="deleteFroggoTeam"
      >
        {{ $t("message.froggoTeams.deleteTeam") }}
      </div>
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
  ADD_MEMBER,
  REMOVE_MEMBER,
} from '../store/mutation-types';
import ClickableDropdown from './clickable-dropdown';
import showMessageMixin from '../mixins/showMessageMixin';

export default {
  mixins: [showMessageMixin],
  beforeMount() {
    this.$store.commit(TEAM_NAME, this.froggoTeam.name);
    this.$store.commit(LOAD_MEMBERS, { members: this.froggoTeamMembers,
      possibleMembers: this.organizationMembers });
  },
  data() {
    return {
      dropdownTitle: 'Usuarios',
      noUsersMessage: 'No se encontraron usuarios',
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
          this.$store.commit(TEAM_NAME, this.newName);
        })
        .catch(() => {
          this.showMessage('nombre existente');
        });
    },
    onItemClicked({ item }) {
      this.addMember(item);
    },
    addMember(user) {
      if (this.froggoTeamMembers.some(u => u.id === user.id)) {
        const index = this.oldUsers.findIndex(u => u.id === user.id);
        this.oldUsers.splice(index, 1);
      } else {
        this.newUsers = [...this.newUsers, user];
      }
      this.$store.commit(ADD_MEMBER, user);
    },
    removeMember(user, index) {
      if (this.froggoTeamMembers.some(u => u.id === user.id)) {
        this.oldUsers = [...this.oldUsers, user];
      } else {
        const i = this.newUsers.findIndex(u => u.id === user.id);
        this.newUsers.splice(i, 1);
      }
      this.$store.commit(REMOVE_MEMBER, { index, member: user });
    },
    saveFroggoTeam() {
      this.$store.dispatch(UPDATE_FROGGO_TEAM, {
        newMembersIds: this.newUsers.map(user => user.id),
        oldMembersIds: this.oldUsers.map(user => user.id),
        id: this.froggoTeam.id,
      })
        .then(() => {
          this.showMessage('equipo guardaro');
          this.newUsers = [];
          this.oldUsers = [];
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
    ClickableDropdown,
  },
  computed: mapState({
    teamName: state => state.froggoTeam.teamName,
    currentMembers: state => state.froggoTeam.currentMembers,
    possibleMembers: state => state.froggoTeam.possibleMembers,
  }),
};
</script>

