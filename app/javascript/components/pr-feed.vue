<template>
  <ul
    class="card-pr__list"
  >
    <li
      v-for="pullRequest in prCopy"
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
            {{ pullRequest.likes.total }}
          </p>
          <div v-if="!(likesGiven.includes(pullRequest.id) || pullRequest.hidden)">
            <button
              class="card-pr__button"
              @click="toggleLike(pullRequest)"
            >
              Like
            </button>
          </div>
          <div v-else>
            <button
              class="card-pr__button"
            >
              Liked
            </button>
          </div>
        </div>
      </div>
    </li>
  </ul>
</template>

<script>

import axios from 'axios';

export default {
  props: {
    pullRequests: {
      type: Array,
      required: true,
    },
    likesGiven: {
      type: Array,
      required: true,
    },
  },

  data() {
    return {
      prCopy: [...this.pullRequests],
    };
  },

  methods: {

    toggleLike(pr) {
      axios.post(
        `/api/pull_requests/${pr.id}/likes`,
      ).then(() => {
        pr.likes.total += 1;
        pr.hidden = true;
      }).catch(() => {
        // eslint-disable-next-line no-alert
        alert('No se pudo crear el like (solo se puede dar un like por PR)');
      });
    },
  },
};
</script>
