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
        <div class="flex flex-row justify-between">
          <p class="text-lg font-semibold mb-6">
            Mis datos
          </p>
        </div>
        <p class="text-sm font-semibold mb-1">
          Acerca de mí
        </p>
        <p class="mb-4">
          {{ githubUser.description }}
        </p>
        <p class="text-sm font-semibold mb-1">
          Mis tags
        </p>
        <div class="flex flex-row items-center">
          <div
            v-for="tag in userTags"
            :key="tag.id"
            class="px-3 py-2 bg-red-500 rounded-full text-white mr-2"
          >
            {{ tag.name }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  props: {
    githubUser: {
      type: Object,
      required: true,
    },
    githubSession: {
      type: Object,
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
    const init = {
      user: this.githubUser,
      editDescription: false,
      form: {
        description: '',
      },
      readMoreActivated: true,
      errors: '',
      maxLength: 160,
      error: false,
    };
    if (this.githubUser.description) {
      if (this.githubUser.description.length > init.maxLength) {
        init.readMoreActivated = false;
      }
      init.form.description = init.user.description;
    }

    return {
      ...init,
    };
  },
};
</script>
