<template>
  <div>
    <div class="flex flex-row justify-between mb-4">
      <p class="text-md font-semibold">
        Mis equipos
      </p>
      <froggo-button
        :variant="'red'"
        :recommendation="false"
        :disabled="disabled"
        @click="updateAllFroggoTeamMemberships"
      >
        Desactivar todos
      </froggo-button>
    </div>
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
import FroggoButton from '../../components/shared/froggo-button.vue';
import froggoTeamMembershipsApi from '../../api/froggo_team_memberships';

export default {
  components: {
    FroggoButton,
  },
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
    disabled() {
      const state = [];
      for (const [, membership] of Object.entries(this.froggoTeamMemberships)) {
        state.push(membership.isMemberActive);
      }
      const trues = state.filter(Boolean).length;

      return trues === 0;
    },
  },
  methods: {
    getFroggoTeamMemberships() {
      froggoTeamMembershipsApi.getFroggoTeamMemberships(this.githubUser.id)
        .then((response) => {
          this.froggoTeamMemberships = this.saveResponseMemberships(response);
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
    updateAllFroggoTeamMemberships() {
      const newMembershipStatus = {
        isMemberActive: false,
      };
      froggoTeamMembershipsApi.updateAllFroggoTeamMemberships(this.githubUser.id, newMembershipStatus)
        .then((response) => {
          this.froggoTeamMemberships = this.saveResponseMemberships(response);
          this.error = false;
        }).catch(() => {
          this.error = true;
          this.errors = 'No se pudieron cambiar los estados';
        });
    },
    saveResponseMemberships(response) {
      const froggoTeamMemberships = {};
      response.data.data.forEach((membership) => {
        froggoTeamMemberships[membership.id] = membership.attributes;
      });

      return froggoTeamMemberships;
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
