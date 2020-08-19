<template>
  <ul
    class="card-pr__list"
  >
    <li
      v-for="pullRequest in pullRequests"
      :key="pullRequest.id"
    >
      <div class="card-pr__orientation">
        <div class="card-pr">
          <a
            class="card-pr__name"
            :href="pullRequest.html_url"
          >
            {{ pullRequest.title }}
          </a>
          <p class="card-pr__project">
            {{ pullRequest.repository_name }}
          </p>
        </div>
        <div class="card-pr__card">
          <p class="card-pr__circle">
            {{ 0 }}
          </p>
          <button class="card-pr__button">
            Like
          </button>
        </div>
      </div>
    </li>
  </ul>
</template>

<script>
export default {
  props: {
    pullRequests: {
      type: Array,
      required: true,
    },
  },
};
</script>
