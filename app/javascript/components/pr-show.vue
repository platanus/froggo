<template>
  <div class="card-pr__list">
    <div class="card-pr-title-show">
      {{ prCompleteInformation.title }}
    </div>
    <div>
      <div style="margin-left: 100px; margin-right: 100px;">
        <div class="card-pr-show">
          <div
            style="display: flex; justify-content: flex-end;"
          >
            <p class="card-pr__circle">
              {{ prCompleteInformation.likes }}
            </p>
            <div v-if="!(prCompleteInformation.currentUserLike)">
              <button
                class="card-pr__button"
                @click="toggleLike(prCompleteInformation)"
              >
                Like
              </button>
            </div>
            <div v-else>
              <button
                class="card-pr__button"
                @click="deleteLike(prCompleteInformation)"
              >
                Dislike
              </button>
            </div>
          </div>
          <div
            style="display: flex; flex-direction: row;"
          >
            <div
              style="flex: 1; display: flex; flex-direction: row;"
            >
              <div
                style="flex: 1;"
              >
                <p>
                  {{ $t("message.prFeed.prAuthor") }}:
                </p>
                <p>{{ $t("message.prFeed.prProject") }}:</p>
                <p>{{ $t("message.prFeed.prDate") }}:</p>
                <p>{{ $t("message.prFeed.prTime") }}:</p>
                <p>{{ $t("message.prFeed.prCommits") }}:</p>
                <p>{{ $t("message.prFeed.prReviewers") }}:</p>
              </div>
              <div
                style="flex: 2;"
              >
                <p>
                  {{ prAttribute(prCompleteInformation.ownerName ?
                    prCompleteInformation.ownerName : prCompleteInformation.ownerLogin) }}
                </p>
                <p>
                  {{ prCompleteInformation.repositoryName }}
                </p>
                <p>
                  {{ prDate(prCompleteInformation) }}
                </p>
                <p>
                  {{ prTime(prCompleteInformation) }}
                </p>
                <p>
                  {{ prAttribute(prCompleteInformation.commits) }}
                </p>
                <div>
                  <div
                    v-if="(prCompleteInformation.reviewers)"
                    style="flex: 2;"
                  >
                    <div
                      v-for="reviewer in prCompleteInformation.reviewers"
                      :key="reviewer.id"
                    >
                      <div v-if="(reviewer.githubUserName)">
                        {{ reviewer.githubUserName }}
                      </div>
                      <div v-else>
                        {{ reviewer.githubUserLogin }}
                      </div>
                    </div>
                  </div>
                  <div
                    v-else
                    style="flex: 2;"
                  >
                    {{ $t("message.prFeed.noName") }}
                  </div>
                </div>
              </div>
            </div>
            <div
              style="flex: 1;"
            >
              <p>{{ $t("message.prFeed.prDescription") }}:</p>
              <p> {{ prAttribute(prCompleteInformation.description) }} </p>
            </div>
          </div>
          <div
            style="text-align: center;"
          >
            <a
              target="_blank"
              :href="prCompleteInformation.htmlUrl"
            > {{ $t("message.prFeed.prGoToGithub") }} </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import moment from 'moment';
import { decamelizeKeys } from 'humps';

export default {
  props: {
    pullRequest: {
      type: Object,
      required: true,
    },
    liked: {
      type: Boolean,
      required: true,
    },
    reviewers: {
      type: Array,
      required: true,
    },
  },

  data() {
    const prCompleteInformation =
      { ...this.pullRequest, currentUserLike: this.liked, reviewers: this.reviewers };

    return {
      prCompleteInformation,
    };
  },

  methods: {
    toggleLike(pr) {
      axios
        .post(`/api/pull_requests/${pr.id}/likes`, decamelizeKeys)
        .then((response) => {
          pr.likes += 1;
          pr.currentUserLike = response.data;
        })
        .catch(() => {
          // eslint-disable-next-line no-alert
          alert('No se pudo crear el like (solo se puede dar un like por PR)');
        });
    },
    deleteLike(pr) {
      axios
        .delete(`/api/pull_requests/${pr.id}/likes/${pr.currentUserLike.id}`)
        .then(() => {
          pr.likes -= 1;
          pr.currentUserLike = undefined;
        })
        .catch(() => {
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
    prAttribute(att) {
      return att || '---';
    },
  },
};
</script>
