<template>
  <div>
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
    userTags: {
      type: Array,
      required: true,
    },
  },
};
</script>
