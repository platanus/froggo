<template>
  <div>
    <div class="card-pr-title">
      Probando
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
    liked: {
      type: Array,
      required: true,
    },
    reviewers: {
      type: Array,
      required: true,
    },

  },

  data() {
    let prCompleteInformation = this.pullRequest;
    const liked = this.liked;
    const reviewers = this.reviewers;
    prCompleteInformation = liked ? { ...prCompleteInformation, currentUserLike: liked } : prCompleteInformation;
    prCompleteInformation = reviewers ? { ...prCompleteInformation, prReviewer: reviewers } : prCompleteInformation;

    return prCompleteInformation;
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
