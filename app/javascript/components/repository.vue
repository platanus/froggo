<template>
  <div>
    <div v-if="repository.tracked" v-on:click="untrack()" class="button button--light">untrack</div>
    <div v-else v-on:click="track()" class="button">track</div>
    <div class="card-extended__repo-name">
      <a :href="repository.html_url" target="_blank" class="card-extended__link">{{ repository.name }}</a>
      <div class="card-extended__last-update">{{ $t("message.settings.repoUpdate") }} {{ repoDate }}</div>
    </div>
  </div>
</template>

<script>
import repositoriesApi from '../api/repositories';

export default {
  data() {
    return {
      repository: this.value,
    };
  },
  computed: {
    repoDate() {
      return new Date(this.repository.gh_updated_at).toLocaleDateString();
    },
  },
  props: ['value'],
  methods: {
    track() {
      this.setTrackedStatus(true);
    },
    untrack() {
      this.setTrackedStatus(false);
    },
    setTrackedStatus(status) {
      this.repository.tracked = status;
      repositoriesApi.updateRepository(this.repository.id, { tracked: status })
        .then((response) => {
          console.log(response);
        })
        .catch((error) => {
          console.log(error);
        });
    },
  },
};
</script>
