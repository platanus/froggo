<template>
  <div>
    <div class="froggo-teams-from-organization">
      <div
        class="froggo-teams-from-organization__organization"
        v-for="organization in organizations"
        :key="organization.id"
      >
        <div class="froggo-teams-from-organization__organization-bar">
          <div class="froggo-teams-from-organization__organization-title">
            {{ $t("message.froggoTeams.organizationTitle") }}
          </div>
          <div class="froggo-teams-from-organization__organization-name">
            {{ organization.login }}
          </div>
          <div class="froggo-teams-from-organization__organization-create-button">
            <div
              class="froggo-teams-from-organization__create-button"
              @click="newFroggoTeam(organization.id)"
            >
              {{ $t("message.froggoTeams.createButton") }}
            </div>
          </div>
        </div>
        <div class="froggo-teams-from-organization__organization-teams-section">
          <div class="froggo-teams-from-organization__teams-section">
            <div class="froggo-teams-from-organization__belonged-teams-title">
              {{ $t("message.froggoTeams.belongedTeams") }}
            </div>
            <div class="froggo-teams-from-organization__belonged-teams">
              <div
                class="froggo-teams-from-organization__organization-team-bar"
                v-for="team in getBelongedTeams(organization.teams)"
                :key="team.id"
              >
                <a
                  class="froggo-teams-from-organization__organization-team-name"
                  :href="`/froggo_teams/${team.id}`"
                >
                  <div class="froggo-teams-from-organization__organization-team">
                    {{ team.name }}
                  </div>
                </a>
              </div>
            </div>
          </div>
          <div class="froggo-teams-from-organization__teams-section">
            <div class="froggo-teams-from-organization__not-belonged-teams-title">
              {{ $t("message.froggoTeams.notBelongedTeams") }}
            </div>
            <div class="froggo-teams-from-organization__not-belonged-teams">
              <div
                class="froggo-teams-from-organization__organization-team-bar"
                v-for="team in getNotBelongedTeams(organization.teams)"
                :key="team.id"
              >
                <a
                  class="froggo-teams-from-organization__organization-team-name"
                  :href="`/froggo_teams/${team.id}`"
                >
                  <div class="froggo-teams-from-organization__organization-team">
                    {{ team.name }}
                  </div>
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
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
    getBelongedTeams(teams) {
      const belongedTeams = teams.filter(team => this.userTeams.includes(team.id));

      return belongedTeams;
    },
    getNotBelongedTeams(teams) {
      const notBelongedTeams = teams.filter(team => !this.userTeams.includes(team.id));

      return notBelongedTeams;
    },
  },
};
</script>
