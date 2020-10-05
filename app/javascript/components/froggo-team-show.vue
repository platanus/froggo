<template>
  <div class="froggo-teams-show">
    <div class="froggo-teams-show__name">
      <div class="froggo-teams-show__name-container">
        {{ froggoTeam.name }}
      </div>
    </div>
    <div class="froggo-teams-show__members">
      <div class="froggo-teams-show__member-title">
        {{ $t("message.froggoTeams.members") }}
        ( {{ froggoTeamMembers.length }} )
      </div>
      <div
        class="froggo-teams-show__member-container"
        v-for="(user) in froggoTeamMembers"
        :key="user.id"
      >
        <a
          class="froggo-teams-show__member-container-info"
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
        <div class="froggo-teams-show__member-container-options">
          <label class="switch">
            <input
              type="checkbox"
              :checked="user.active"
              @click="changeMemberActivation(user)"
            >
            <span class="slider" />
          </label>
        </div>
      </div>
    </div>
    <div class="froggo-teams-show__end-section">
      <div
        class="froggo-teams-show__white-button"
        @click="editTeam"
      >
        {{ $t("message.froggoTeams.editTeam") }}
      </div>
      <div
        class="froggo-teams-show__light-blue-button"
        @click="saveMembersState"
      >
        {{ $t("message.froggoTeams.saveChanges") }}
      </div>
    </div>
  </div>
</template>

<script>
import {
  UPDATE_FROGGO_TEAM,
} from '../store/action-types';
import showMessageMixin from '../mixins/showMessageMixin';

export default {
  mixins: [showMessageMixin],
  data() {
    return {
      originalMembersStates: this.loadMembersStates(),
    };
  },
  props: {
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
    changeMemberActivation(user) {
      user.active = !user.active;
    },
    saveMembersState() {
      this.$store.dispatch(UPDATE_FROGGO_TEAM, {
        id: this.froggoTeam.id,
        changedMembersIds: this.getChangedMembersIds(),
      })
        .then(() => {
          this.showMessage(this.$i18n.t('message.froggoTeams.successfullySavedChanges'));
          window.location.reload(true);
        })
        .catch(() => {
          this.showMessage(this.$i18n.t('message.settings.error'));
        });
    },
    getChangedMembersIds() {
      const changedMembers = this.froggoTeamMembers
        .filter(member => member.active !== this.originalMembersStates[member.id]);

      return changedMembers.map(user => user.id);
    },
    editTeam() {
      window.location.href = `/froggo_teams/${this.froggoTeam.id}/edit`;
    },
    loadMembersStates() {
      const membersState = {};

      this.froggoTeamMembers.forEach((team) => {
        membersState[team.id] = team.active;
      });

      return membersState;
    },
  },
};
</script>

