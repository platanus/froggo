<template>
  <ul
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
          {{ $t("message.prFeed.prDate") }}
        </div>
      </div>
      <div class="card-pr-title__header-button">
        Likes
      </div>
    </div>
    <li
      v-for="pullRequest in prWithLikes"
      :key="pullRequest.id"
    >
      <div class="card-pr__orientation">
        <div class="card-pr">
          <a
            class="card-pr__name"
            target="_blank"
            :href="pullRequest.htmlUrl"
          >
            {{ pullRequest.title }}
          </a>
          <p
            v-if="(pullRequest.ownerName)"
            style="flex: 2;"
          >
            {{ pullRequest.ownerName }}
          </p>
          <p
            v-else-if="(pullRequest.ownerLogin)"
            style="flex: 2;"
          >
            {{ pullRequest.ownerLogin }}
          </p>
          <p
            v-else
            style="flex: 2;"
          >
            {{ $t("message.prFeed.noName") }}
          </p>
          <p class="card-pr__project">
            {{ pullRequest.repositoryName }}
          </p>
          <p style="flex: 2;">
            {{ prDate(pullRequest) }}
          </p>
        </div>
        <div class="card-pr__card">
          <p class="card-pr__circle">
            {{ pullRequest.likes }}
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
          <a
            :href="`/organizations/${organizationName}/pull_requests/${pullRequest.id}`"
          >
            <button
              class="card-pr__button"
            >
              {{ $t("message.prFeed.prSee") }}
            </button>
          </a>
        </div>
      </div>
    </li>
  </ul>
</template>

<script>

import axios from 'axios';
import moment from 'moment';
import { decamelizeKeys } from 'humps';

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
    organizationName: {
      type: String,
      required: true,
    },
  },

  data() {
    return {
      prWithLikes: this.pullRequests.map((pr) => {
        const liked = this.likesGiven.find((like) => like.likeableId === pr.id);

        return liked ? { ...pr, currentUserLike: liked } : pr;
      }),
    };
  },

  methods: {

    toggleLike(pr) {
      axios.post(
        `/api/pull_requests/${pr.id}/likes`, decamelizeKeys,
      ).then(response => {
        pr.likes += 1;
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
        pr.likes -= 1;
        pr.currentUserLike = undefined;
      }).catch(() => {
        // eslint-disable-next-line no-alert
        alert('No se pudo borrar el like (no haz dado like primero)');
      });
    },
    prDate(pr) {
      return moment(pr.createdAt).format('DD-MM-YYYY');
    },
    prTime(pr) {
      const timeZone = 4;

      return moment(pr.createdAt).add(timeZone, 'hours').format('LT');
    },
  },
};
</script>
