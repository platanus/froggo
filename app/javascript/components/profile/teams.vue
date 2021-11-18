<template>
  <div>
    <p class="text-md font-semibold mb-4">
      Mis equipos
    </p>
    <p
      v-if="canEdit && error"
      class="text-red-500 bg-opacity-50 mb-1"
    >
      {{ errors }}
    </p>
    <div class="grid grid-flow-row grid-cols-2 px-1">
      <ul
        v-for="(membership, id) in froggoTeamMemberships"
        :key="id"
        class="list-inside py-2"
        :class="[listType]"
      >
        <li class="text-md">
          <label
            v-if="canEdit"
            class="switch mr-1"
          >
            <input
              type="checkbox"
              :checked="membership.isMemberActive"
              @click="updateFroggoTeamMembership(id)"
            >
            <span class="slider" />
          </label>
          {{ froggoTeams[membership.froggoTeamId].name }}
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import froggoTeamMembershipsApi from '../../api/froggo_team_memberships';

export default {
  props: {
    canEdit: {
      type: Boolean,
      default: false,
    },
    githubUser: {
      type: Object,
      required: true,
    },
    githubSession: {
      type: Object,
      required: true,
    },
    teams: {
      type: Array,
      default: () => {},
    },
  },
  computed: {
    listType() {
      return this.canEdit ? '' : 'list-disc';
    },
  },
  methods: {
    getFroggoTeamMemberships() {
      froggoTeamMembershipsApi.getFroggoTeamMemberships(this.githubUser.id)
        .then((response) => {
          this.froggoTeamMemberships = {};

          response.data.data.forEach((membership) => {
            this.froggoTeamMemberships[membership.id] = membership.attributes;
          });
        });
    },
    newMembershipStatus(froggoTeamMembershipId) {
      return !this.froggoTeamMemberships[froggoTeamMembershipId].isMemberActive;
    },
    updateFroggoTeamMembership(froggoTeamMembershipId) {
      const newMembershipStatus = {
        isMemberActive: this.newMembershipStatus(froggoTeamMembershipId),
      };
      froggoTeamMembershipsApi.updateFroggoTeamMembership(froggoTeamMembershipId, newMembershipStatus)
        .then((response) => {
          this.froggoTeamMemberships[response.data.data.id] = response.data.data.attributes;
          this.error = false;
        }).catch(() => {
          this.error = true;
          this.errors = 'No se pudo cambiar el estado';
        });
    },
  },
  mounted() {
    this.getFroggoTeamMemberships();
    this.teams.forEach((team) => {
      this.froggoTeams[team.id] = team;
    });
  },
  data() {
    return {
      froggoTeams: {},
      froggoTeamMemberships: {},
      error: false,
      errors: '',
    };
  },
};
</script>
