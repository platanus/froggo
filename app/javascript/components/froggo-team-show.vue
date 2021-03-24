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
        v-for="(user) in teamMembers"
        :key="user.id"
      >
        <a
          class="froggo-teams-show__member-container-info"
          :href="`/users/${user.id}`"
        >
          <img
            class="froggo-teams-show__picture"
            :src="user.avatarUrl"
          >
          <div class="froggo-teams-show__username">
            {{ user.login }}
          </div>
        </a>
        <div class="froggo-teams-show__member-container-options">
          <percentage-dropdown
            :user="user"
          />
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
import showMessageMixin from '../mixins/showMessageMixin';
import {
  UPDATE_FROGGO_TEAM,
} from '../store/action-types';

export default {
  mixins: [showMessageMixin],
  data() {
    return {
      originalMembersStates: this.loadMembersStates(),
      originalMembersPercentages: this.loadMembersPercentages(),
      teamMembers: this.froggoTeamMembers,
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
        changedMembersIds: this.changedMembersIds,
        changedPercentages: this.changedPercentages,
      })
        .then(() => {
          this.showMessage(this.$i18n.t('message.froggoTeams.successfullySavedChanges'));
          window.location.reload(true);
        })
        .catch(() => {
          this.showMessage(this.$i18n.t('message.settings.error'));
        });
    },
    editTeam() {
      window.location.href = `/froggo_teams/${this.froggoTeam.id}/edit`;
    },
    loadMembersStates() {
      const membersState = {};

      this.froggoTeamMembers.forEach((member) => {
        membersState[member.id] = member.active;
      });

      return membersState;
    },
    loadMembersPercentages() {
      const membersPercentages = {};

      this.froggoTeamMembers.forEach((member) => {
        membersPercentages[member.id] = member.percentage;
      });

      return membersPercentages;
    },
  },
  computed: {
    changedMembersIds() {
      return this.teamMembers
        .filter(member => member.active !== this.originalMembersStates[member.id])
        .map(user => user.id);
    },
    changedPercentages() {
      return this.teamMembers
        .filter(member => member.percentage !== this.originalMembersPercentages[member.id])
        .reduce((finalObj, member) => {
          finalObj[member.id] = member.percentage;

          return finalObj;
        }, {});
    },
  },
};
</script>

