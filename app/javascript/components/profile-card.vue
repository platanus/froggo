<template>
  <div class="grid grid-cols-8 px-14 font-sans">
    <div class="col-span-2">
      <div class="flex flex-col items-center">
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
    </div>
    <div class="col-span-6 divide-y divide-gray-400 divide-solid">
      <div class="flex flex-col pb-10">
        <info
          :github-user="githubUser"
          :github-session="githubSession"
          :user-tags="userTags"
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
          :github-session="githubSession"
          :teams="teams"
          :timespans="timespans"
        />
      </div>
    </div>
  </div>
</template>

<script>
import Configuration from './profile/configuration.vue';
import Info from './profile/info.vue';
import Teams from './profile/teams.vue';

export default {
  components: {
    Configuration,
    Info,
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
