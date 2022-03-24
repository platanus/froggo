<template>
  <div class="flex flex-col">
    <div class="flex justify-between mb-10">
      <input
        class="w-64 p-2 border rounded-md focus:outline-none"
        type="text"
        placeholder="Busca un equipo"
      >
      <button
        class="w-56 p-2 text-white bg-green-600 border rounded-md"
        @click="newFroggoTeam"
      >
        {{ $t('message.froggoTeams.newTeam') }}
      </button>
    </div>
    <h1 class="mb-5 text-xl">
      {{ $t('message.froggoTeams.myTeams') }}
    </h1>
    <div class="flex flex-col p-4 text-lg border rounded-t-md">
      {{ $t('message.froggoTeams.numberOfTeamsInOrganization', {
        'numberOfTeams': belongedTeamsLength, 'organizationLogin': selectedOrganizationLogin }) }}
    </div>
    <div
      class="flex items-center justify-between p-4 text-lg border border-t-0"
      :class="{ 'rounded-b-md mb-5': index === belongedTeamsLength - 1 }"
      v-for="(team, index) in belongedTeams"
      :key="team.id"
    >
      <a
        :href="`/froggo_teams/${team.id}`"
        class="text-blue-400 underline"
      >
        {{ team.name }}
      </a>
      <div class="flex">
        <img
          class="w-5 h-5 mr-1 rounded-full"
          v-for="user in usersToShow(team.githubUsers)"
          :key="user.id"
          :src="user.avatarUrl"
        >
        <p class="ml-2 text-sm">
          {{ $t('message.froggoTeams.numberOfMembers', { 'membersLength': team.githubUsers.length }) }}
        </p>
      </div>
    </div>
    <h1 class="mb-5 text-xl">
      {{ $t('message.froggoTeams.notBelongedTeams') }}
    </h1>
    <div class="flex flex-col p-4 text-lg border rounded-t-md">
      {{ $t('message.froggoTeams.numberOfTeamsInOrganization', {
        'numberOfTeams': notBelongedTeamsLength, 'organizationLogin': selectedOrganizationLogin }) }}
    </div>
    <div
      class="flex items-center justify-between p-4 text-lg border border-t-0"
      :class="{ 'rounded-b-md mb-5': index === notBelongedTeamsLength - 1 }"
      v-for="(team, index) in notBelongedTeams"
      :key="`not-belonged-${team.id}`"
    >
      <a
        :href="`/froggo_teams/${team.id}`"
        class="text-blue-400 underline"
      >
        {{ team.attributes.name }}
      </a>
      <div class="flex">
        <img
          class="w-5 h-5 mr-1 rounded-full"
          v-for="user in usersToShow(teamWithUsers[team.id])"
          :key="user.attributes.id"
          :src="user.attributes.avatarUrl"
        >
        <p class="ml-2 text-sm">
          {{ $t('message.froggoTeams.numberOfMembers', {
            'membersLength': team.relationships.githubUsers.data.length })
          }}
        </p>
      </div>
    </div>
  </div>
</template>
<script>
import { mapState } from 'vuex';
import froggoTeamApi from '../api/froggo_teams';
import userApi from '../api/users';

const MAX_NUMBER_OF_USERS = 10;

export default {
  props: {
    userTeams: {
      type: Array,
      required: true,
    },
    organizations: {
      type: Array,
      required: true,
    },
  },
  data() {
    return {
      organizationTeams: [],
      teamWithUsers: {},
    };
  },
  watch: {
    '$store.state.preferences.organization': async function (newOrganzation) {
      if (newOrganzation) await this.getAndSetFroggoTeams();
    },
    async notBelongedTeams(newTeams) {
      if (newTeams && newTeams.length > 0) {
        this.teamWithUsers = await Promise.all(newTeams.map(async (team) =>
          ({ teamId: team.id, users: (await userApi.getUsersFromFroggoTeam(team.id)).data.data }),
        ));
        const teamWithUsers = this.teamWithUsers.reduce((allObjects, teamWithUser) =>
          ({ ...allObjects, [teamWithUser.teamId]: teamWithUser.users }), {});
        this.teamWithUsers = teamWithUsers;
      }
    },
  },
  computed: {
    ...mapState({
      selectedOrganization: state => state.preferences.organization,
    }),
    userTeamsIds() {
      return this.userTeams.map(team => team.id);
    },
    belongedTeams() {
      if (!this.selectedOrganization) return null;

      return this.userTeams.filter(team => this.selectedOrganization.id === team.organization.id);
    },
    notBelongedTeams() {
      if (!this.selectedOrganization || this.organizationTeams.length === 0) return null;

      return this.organizationTeams.filter((team) => !this.userTeamsIds.includes(parseInt(team.id, 10)));
    },
    belongedTeamsLength() {
      return this.selectedOrganization ? this.belongedTeams.length : null;
    },
    notBelongedTeamsLength() {
      return this.selectedOrganization && this.notBelongedTeams ? this.notBelongedTeams.length : null;
    },
    selectedOrganizationLogin() {
      return this.selectedOrganization ? this.selectedOrganization.login : '';
    },
  },
  methods: {
    newFroggoTeam() {
      if (this.selectedOrganization) {
        window.location.href = `/organizations/${this.selectedOrganization.id}/froggo_teams/new`;
      }
    },
    usersToShow(githubUsers) {
      if (githubUsers && githubUsers.length > MAX_NUMBER_OF_USERS) {
        return githubUsers.slice(0, MAX_NUMBER_OF_USERS);
      }

      return githubUsers;
    },
    async getAndSetFroggoTeams() {
      const body = { 'withUsers': true };
      const response = await froggoTeamApi.getFroggoTeams(this.selectedOrganization.id, body);
      this.organizationTeams = response.data.data;
    },
  },
};
</script>
