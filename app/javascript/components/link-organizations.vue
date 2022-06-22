<template>
  <div>
    <div
      class="flex items-center w-full p-4 bg-red-200"
      v-if="error"
    >
      <img
        class="p-2"
        :src="require('../../assets/images/icons/error-icon.svg').default"
      >
      <p>
        {{ this.errors }}
      </p>
    </div>
    <div class="flex flex-col items-center min-h-screen mt-10">
      <div class="flex flex-col items-center justify-center max-w-screen-sm p-10 shadow-2xl">
        <h1 class="pb-10 text-xl font-bold">
          Vincula tus organizaciones de Github con Froggo
        </h1>
        <div class="flex justify-center">
          <img
            class="p-1"
            :src="require('../../assets/images/froggo-logo-green.svg').default"
          >
          <img
            class="p-1"
            :src="require('../../assets/images/two-way-arrows.svg').default"
          >
          <img
            class="p-1"
            :src="require('../../assets/images/github-logo.svg').default"
          >
        </div>
        <p class="px-4 pt-5 pb-8 text-justify">
          {{ $t("message.froggoTeams.linkOrganizationMessage") }}
        </p>
        <div
          v-for="(organization) in organizations"
          :key="organization.login"
          class="flex w-5/6"
        >
          <multi-checkbox-organizations
            :id="organization.login"
            :label="organization.login"
            :input-value="organization"
            v-model="selectedOrganizations"
            :avatar="organization.avatarUrl"
            :role="organization.role"
          />
        </div>
        <button
          class="w-64 p-2 mt-10 text-white border rounded-md align-end justify-self-center bg-froggoGreen-500 focus:outline-none hover:bg-green-700"
          @click="linkOrganizations()"
        >
          {{ $t("message.froggoTeams.linkOrganizationButton") }}
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import OrganizationsApi from '../api/organizations';

export default {
  data() {
    return {
      selectedOrganizations: [],
      errors: '',
      error: false,
    };
  },
  props: {
    organizations: {
      type: Array,
      required: true,
    },
  },
  methods: {
    linkOrganizations() {
      const body = { selectedOrganizations: this.selectedOrganizations };
      OrganizationsApi.createAll(body)
        .then(() => {
          window.location.href = '/tracked_organizations';
        }).catch(() => {
          this.error = true;
          this.errors = 'Ha ocurrido un error, inténtalo de nuevo';
        });
    },
  },
};
</script>
