<template>
  <div class="flex flex-col items-center lg:flex-row xl:flex-row lg:items-start xl:items-start px-14 font-sans">
    <div class="flex flex-col items-center w-full overflow-x-auto lg:w-1/4 xl:w-1/4 mx-8 mb-8">
      <img
        :src="githubUser.avatarUrl"
        class="rounded-full w-48 h-48 mb-4"
      >
      <div class="flex flex-col items-center text-base">
        <p class="mb-4">
          {{ githubUser.name || t('messages.profile.no_name') }}
        </p>

        <a
          target="_blank"
          :href="githubUser.htmlUrl"
          class="flex items-center"
        >
          <img
            class="w-6 mr-1.5"
            src="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"
          >
          <span>
            @{{ githubUser.login }}
          </span>
        </a>
      </div>
    </div>
    <div class="w-3/4 divide-y divide-gray-400 divide-solid">
      <div class="flex flex-col pb-10">
        <information
          :github-user="githubUser"
          :github-session="githubSession"
          :user-tags="userTags"
          :tags="tags"
        />
      </div>
      <div class="flex flex-col py-10">
        <teams
          :github-user="githubUser"
          :github-session="githubSession"
          :teams="teams"
        />
      </div>
      <div
        class="flex flex-col py-10"
        v-if="canEdit"
      >
        <configuration
          :github-user="githubUser"
          :teams="teams"
          :timespans="timespans"
        />
      </div>
    </div>
  </div>
</template>

<script>
import Configuration from './profile/configuration.vue';
import Information from './profile/information.vue';
import Teams from './profile/teams.vue';

export default {
  components: {
    Configuration,
    Information,
    Teams,
  },
  props: {
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
    timespans: {
      type: Array,
      required: true,
    },
    tags: {
      type: Array,
      required: true,
    },
    userTags: {
      type: Array,
      required: true,
    },
  },
  data() {
    return {
      canEdit: this.githubSession.user.id === this.githubUser.id,
    };
  },
};
</script>
