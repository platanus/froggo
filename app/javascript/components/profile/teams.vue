<template>
  <div>
    <p class="text-md font-semibold mb-5">
      Mis equipos
    </p>
    <ul
      v-for="team in teams"
      :key="team.id"
      class="list-disc list-inside"
    >
      <li class="text-md mb-5">
        {{ team.name }}
      </li>
    </ul>
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
    teams: {
      type: Array,
      default: () => {},
    },
  },
};
</script>
