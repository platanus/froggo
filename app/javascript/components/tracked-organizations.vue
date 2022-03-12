<template>
  <div
    class="flex flex-col items-center"
  >
    <div
      class="flex flex-col items-start w-full px-8 py-4 bg-blue-100"
      v-if="organizationsWithoutTracking.length > 0"
    >
      <p
        class="text-blue-500"
      >
        {{ $t('message.organization.organizationsWithoutTracking', {
          organizationsWithoutTracking: organizationsWithoutTracking.length
        }) }}
      </p>
      <ul
        class="pl-10 text-blue-600 list-disc"
      >
        <li
          v-for="organization in organizationsWithoutTracking"
          :key="organization"
        >
          {{ organization.login }}
        </li>
      </ul>
    </div>
    <h1
      class="flex flex-row flex-wrap w-full pl-10 mt-10 text-lg"
    >
      {{ $t('message.organization.myOrganizations') }}
    </h1>
    <div
      class="flex flex-row flex-wrap w-full p-4 pl-10 "
    >
      <div
        v-for="(organization) in organizations"
        :key="organization.login"
        class="w-2/5 p-4 m-4 border-2 border-solid rounded-lg border-slate-300"
      >
        <label
          :for="organization.id"
          class="flex items-center w-full"
        >
          <img
            :src="organization.avatarUrl"
            class="h-12 mr-4"
          >
          <a
            v-if="organization.role==='admin'"
            :href=" `/organizations/${organization.login}/settings`"
            class="text-lg cursor-pointer"
          >
            {{ organization.login }}
          </a>
          <span
            v-else
            class="text-lg"
          >{{ organization.login }} </span>
          <span class="ml-auto text-sm">
            {{ capitalizeRole(organization.role) }}
          </span>
        </label>
        <span class="float-right text-sm text-gray-400">
          {{ $t('message.organization.tracking', {
            trackedRepositories: organization.trackedRepositories,
            totalRepositories: organization.totalRepositories,
          }) }}
        </span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    organizations: {
      type: Array,
      required: true,
    },
  },
  computed: {
    organizationsWithoutTracking() {
      return this.organizations.filter((organization) =>
        organization.totalRepositories > 0 && organization.role === 'admin' && organization.trackedRepositories === 0,
      );
    },
  },
  methods: {
    countUntrackedRepos(organization) {
      return `${organization.trackedRepositories}/${organization.totalRepositories}`;
    },
    capitalizeRole(role) {
      return role === 'admin' ? this.$t('message.froggoTeams.adminRole') : this.$t('message.froggoTeams.memberRole');
    },
  },
};
</script>
