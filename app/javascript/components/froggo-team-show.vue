<template>
  <div class="flex flex-col">
    <div class="flex items-center mb-5">
      <a
        :href="`/github_users/${this.currentUser.id}/froggo_teams`"
        class="mr-6"
      >
        <img :src="require('../../assets/images/icons/back-icon.svg').default">
      </a>
      <p class="mr-6 text-lg">
        {{ froggoTeam.name }}
      </p>
      <button
        class="p-2 mr-6 border border-blue-900 rounded-md focus:outline-none"
        @click="editTeam"
      >
        <img :src="require('../../assets/images/icons/edit-icon.svg').default">
      </button>
      <button
        class="p-2 mr-auto border border-blue-900 rounded-md focus:outline-none"
        @click="showConfirmation('erase')"
      >
        <img :src="require('../../assets/images/icons/delete-icon.svg').default">
      </button>
      <button
        class="w-40 px-2 py-1 text-white border rounded-md"
        :class="{ 'bg-red-600' : currentUserInTeam, 'bg-green-600': !currentUserInTeam }"
        @click="showConfirmation('leave')"
      >
        {{ currentUserInTeam ? 'Dejar el equipo' : 'Unirme' }}
      </button>
    </div>
    <div class="flex p-4 border rounded-t-md">
      {{ froggoTeamMembers.length + $t("message.froggoTeams.members") }}
    </div>
    <div
      class="flex items-center p-4 text-lg border border-t-0"
      :class="{ 'rounded-b-md mb-5': index === teamMembers.length - 1 }"
      v-for="(user, index) in teamMembers"
      :key="`not-belonged-${user.id}`"
    >
      <img
        :src="user.avatarUrl"
        class="w-10 h-10 mr-4 rounded-full"
      >
      <p class="mr-auto text-sm">
        {{ user.name || 'Sin nombre' }} <br>
        @{{ user.login }}
      </p>
      <percentage-dropdown
        class="mr-4 md:mr-32"
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
    <button
      class="self-end w-40 p-2 text-white bg-green-500 border rounded-md hover:bg-green-600"
      @click="saveMembersState"
    >
      Guardar Cambios
    </button>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import ConfirmationActionModal from './shared/confirmation-action-modal.vue';
import showMessageMixin from '../mixins/showMessageMixin';
import {
  UPDATE_FROGGO_TEAM,
  DELETE_FROGGO_TEAM,
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
    showConfirmation(option = 'erase') {
      if (option === 'erase') {
        this.showDeleteTeamConfirmationModal();
      } else if (option === 'leave') {
        this.showLeaveTeamConfirmationModal();
      }
    },
    showDeleteTeamConfirmationModal() {
      const titleMessage = 'Eliminar equipo';
      const confirmationMessage = '¿Estás seguro que deseas eliminar este equipo?';
      const confirmationButtonMessage = 'Eliminar';
      this.showConfirmationActionModal({ titleMessage, confirmationMessage, confirmationButtonMessage,
        action: DELETE_FROGGO_TEAM,
        actionParams: [{ id: this.froggoTeam.id }],
        redirectPath: `/github_users/${this.currentUser.id}/froggo_teams` });
    },
    showLeaveTeamConfirmationModal() {
      const titleMessage = 'Dejar equipo';
      const confirmationMessage = '¿Estás seguro que deseas dejar este equipo?';
      const confirmationButtonMessage = 'Sí, deseo dejar el equipo';
      this.showConfirmationActionModal({ titleMessage, confirmationMessage, confirmationButtonMessage,
        action: UPDATE_FROGGO_TEAM,
        actionParams: [{ id: this.froggoTeam.id, oldMembersIds: [this.currentUser.id] }],
        redirectPath: `/github_users/${this.currentUser.id}/froggo_teams` });
    },
    showConfirmationActionModal(params) {
      this.$modal.show(ConfirmationActionModal, {
        ...params,
      }, {
        width: '100%',
        maxWidth: 768,
        height: 'auto',
        adaptive: true,
        scrollable: true,
        name: 'confirmation-action-modal',
        classes: 'border rounded-md',
      });
    },
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
    ...mapState({
      currentUser: state => state.currentUser,
    }),
    currentUserInTeam() {
      if (!this.currentUser) return null;

      return this.froggoTeam.githubUsers.map(user => user.id).includes(this.currentUser.id);
    },
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

