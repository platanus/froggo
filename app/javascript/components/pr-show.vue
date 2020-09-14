<template>
  <div
    class="card-pr__list"
  >
    <div class="card-pr-title">
      Feed
    </div>
    <div class="card-pr-title__header">
      <div class="card-pr-title__header-card">
        <div class="card-pr-title__name">
          {{ $t("message.prFeed.prName") }}
        </div>
        <div class="card-pr-title__type-1">
          {{ $t("message.prFeed.prAuthor") }}
        </div>
        <div class="card-pr-title__type-1">
          {{ $t("message.prFeed.prProject") }}
        </div>
        <div class="card-pr-title__type-1">
          {{ $t("message.prFeed.prTime") }}
        </div>
        <div class="card-pr-title__type-1">
          {{ $t("message.prFeed.prDate") }}
        </div>
      </div>
      <div class="card-pr-title__header-button">
        Likes
      </div>
    </div>
    <div class="card-pr__orientation">
      <div class="card-pr">
        <a
          class="card-pr__name"
          target="_blank"
          :href="pullRequest.html_url"
        >
          {{ pullRequest.title }}
        </a>
        <p
          v-if="(pullRequest.owner_name)"
          style="flex: 2;"
        >
          {{ pullRequest.owner_name }}
        </p>
        <p
          v-else
          style="flex: 2;"
        >
          {{ $t("message.prFeed.noName") }}
        </p>
        <p class="card-pr__project">
          {{ pullRequest.repository_name }}
        </p>
        <p style="flex: 2;">
          {{ prTime(pullRequest) }}
        </p>
        <p style="flex: 2;">
          {{ prDate(pullRequest) }}
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
  </div>
</template>

<script>

import axios from 'axios';
import moment from 'moment';

export default {
  props: {
    pullRequest: {
      type: Array,
      required: true,
    },
    likesGiven: {
      type: Array,
      required: true,
    },
  },

  data() {
    const pr = this.pullRequest;
    const liked = this.likesGiven.find((like) => like.likeable_id === pr.id);

    return liked ? { ...this.pullRequest, currentUserLike: liked } : this.pullRequest;
  },

  methods: {

    toggleLike(pr) {
      axios.post(
        `/api/pull_requests/${pr.id}/likes`,
      ).then(response => {
        pr.likes.total += 1;
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
        pr.currentUserLike = undefined;
      }).catch(() => {
        // eslint-disable-next-line no-alert
        alert('No se pudo borrar el like (no haz dado like primero)');
      });
    },
    prDate(pr) {
      return moment(pr.created_at).format('DD-MM-YYYY');
    },
    prTime(pr) {
      const timeZone = 4;

      return moment(pr.created_at).add(timeZone, 'hours').format('LT');
    },
  },
};
</script>
