<template>
  <ul
    class="card-pr__list"
  >
    <div class="card-pr-title">
      Feed
    </div>
    <li
      v-for="pullRequest in prWithLikes"
      :key="pullRequest.id"
    >
      <div class="card-pr__orientation">
        <div class="card-pr">
          <div
            style="display: flex;"
          >
            <p class="card-pr__name">
              {{ pullRequest.title }}
            </p>
            <p class="card-pr__project">
              {{ pullRequest.repositoryName }}
            </p>
          </div>
          <div class="card-pr__author">
            {{ $t("message.prFeed.prCreated") }} {{ prOwner(pullRequest) }}
            {{ $t("message.prFeed.prThe") }} {{ prDate(pullRequest) }}
          </div>

          <div
            class="card-pr__buttons"
          >
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
            <a
              target="_blank"
              :href="pullRequest.htmlUrl"
            >
              <img
                class="card-pr__github"
                src="https://www.iconfinder.com/data/icons/octicons/1024/mark-github-512.png"
              >
            </a>
          </div>
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
    prOwner(pr) {
      if (!(pr.ownerName || pr.ownerLogin)) {
        return '----';
      }

      return pr.ownerName ? pr.ownerName : pr.ownerLogin;
    },
  },
};
</script>
