<template>
  <div v-on:click="load()">
    <div class="button" v-if="!loading">{{ $t("message.settings.sync") }}</div>
    <div class="button button--disabled" v-else>{{ $t("message.settings.loading") }}</div>
  </div>
</template>

<script>
/* eslint-disable no-alert */
import axios from 'axios';

export default {
  props: ['id', 'error_msg'],
  data() {
    return {
      loading: false,
    };
  },
  methods: {
    load() {
      if (this.loading) {
        return;
      }
      this.loading = true;
      axios.post(`/api/organizations/${this.id}/sync`)
        .then(() => {
          this.checkSync();
        })
        .catch(() => {
          alert(this.error_msg);
        });
    },
    checkSync() {
      const TIMEOUT = 1000;
      axios.get(`/api/organizations/${this.id}/check_sync`)
        .then((res) => {
          if (res.data.state === 'completed') {
            this.loading = false;
          } else if (res.data.state === 'failed') {
            this.loading = false;
            alert(this.error_msg);
          } else {
            setTimeout(this.checkSync(), TIMEOUT);
          }
        });
    },
  },
};
</script>
