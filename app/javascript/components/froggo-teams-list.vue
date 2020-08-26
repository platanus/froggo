<template>
  <div>
    <div class="froggo-teams-from-organization">
      <div
        v-for="organization in organizations"
        :key="organization.id"
        class="froggo-teams-from-organization__organization"
      >
        <div class="froggo-teams-from-organization__organization-bar">
          <div class="froggo-teams-from-organization__organization-title">
            Organización:   {{ organization.login }}
          </div>
          <div class="froggo-teams-from-organization__organization-create-button">
            <button @click="newFroggoTeam(organization.id)">
              Crear Equipo
            </button>
          </div>
        </div>
        <div class="froggo-teams-from-organization__organization-teams">
          Equipos a los que pertenezco:
        </div>
        <div
          v-for="team in userTeams"
          :key="team.id"
        >
          <a
            :href="`/froggo_teams/${team.id}`"
          >
            <div
              class="froggo-teams-from-organization__organization-team"
              v-if="organization.id === team.organization_id"
            >
              {{ team.name }}
            </div>
          </a>
        </div><br>
      </div><br>
    </div>
  </div>
</template>

<script>

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
  methods: {
    newFroggoTeam(organizationId) {
      window.location.href = `/organizations/${organizationId}/froggo_teams/new`;
    },
  },
};
</script>
