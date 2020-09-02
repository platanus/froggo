<template>
  <ul
    class="card-pr__list"
  >
    <li
      v-for="pullRequest in prWithLikes"
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
          <div v-if="!(pullRequest.currentUserLike)">
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
              @click="deleteLike(pullRequest)"
            >
              Dislike
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
      prWithLikes: this.pullRequests.map((pr) => {
        const liked = this.likesGiven.find((like) => like.likeable_id === pr.id);

        return liked ? { ...pr, currentUserLike: liked } : pr;
      }),
    };
  },

  methods: {

    toggleLike(pr) {
      axios.post(
        `/api/pull_requests/${pr.id}/likes`,
      ).then(response => {
        pr.likes.total += 1;
        pr.hidden = true;
        pr.currentUserLike = response.data;
      }).catch(() => {
        // eslint-disable-next-line no-alert
        alert('No se pudo crear el like (solo se puede dar un like por PR)');
      });
    },
    deleteLike(pr) {
      axios.delete(
        `/api/pull_requests/${pr.id}/likes/${pr.currentUserLike.id}`,
      ).then(() => {
        pr.likes.total -= 1;
        pr.hidden = false;
        pr.currentUserLike = undefined;
      }).catch(() => {
        // eslint-disable-next-line no-alert
        alert('No se pudo borrar el like (no haz dado like primero)');
      });
    },
  },
};
</script>
