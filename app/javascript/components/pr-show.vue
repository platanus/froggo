<template>
  <div class="card-pr__list">
    <div class="card-pr-title-show">
      {{ prCompleteInformation.title }}
    </div>
    <div>
      <div class="card-pr-show__orientation">
        <div class="card-pr-show">
          <div class="card-pr-show__display">
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
          <div class="card-pr-show__info_display">
            <div class="card-pr-show__title_display">
              <div
                class="card-pr-title__column-1"
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
              <div class="card-pr-show__flex2">
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
                    class="card-pr-show__flex2"
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
                    class="card-pr-show__flex2"
                  >
                    {{ $t("message.prFeed.noName") }}
                  </div>
                </div>
              </div>
            </div>
            <div class="card-pr-show__flex1">
              <p
                style="font-weight: bold;"
              >
                {{ $t("message.prFeed.prDescription") }}:
              </p>
              <p> {{ prAttribute(prCompleteInformation.description) }} </p>
            </div>
          </div>
          <div class="card-pr-show__github_display">
            <a
              target="_blank"
              :href="prCompleteInformation.htmlUrl"
            >
              <img
                class="card-pr-show__github"
                src="https://www.iconfinder.com/data/icons/octicons/1024/mark-github-512.png"
              >
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import moment from 'moment';
import pullRequestsApi from '../api/pull_requests';
import showMessageMixin from '../mixins/showMessageMixin';

export default {
  mixins: [showMessageMixin],
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
      pullRequestsApi.addLike(pr.id)
        .then((response) => {
          pr.likes += 1;
          pr.currentUserLike = response.data;
        })
        .catch(() => {
          this.showMessage(this.$i18n.t('message.error.createLike'));
        });
    },
    deleteLike(pr) {
      pullRequestsApi.deleteLike(pr.id, pr.currentUserLike.id)
        .then(() => {
          pr.likes -= 1;
          pr.currentUserLike = undefined;
        })
        .catch(() => {
          this.showMessage(this.$i18n.t('message.error.deleteLike'));
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
