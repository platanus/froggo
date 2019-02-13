<template>
  <div class="loading-icon" v-if="loading"></div>
</template>

<script>
/* eslint-disable no-alert */
import axios from 'axios';

export default {
  props: ['id'],
  data() {
    return {
      loading: false,
    };
  },
  methods: {
    checkSync() {
      const TIMEOUT = 5000;
      axios.get(`/api/organizations/${this.id}/check_sync`)
        .then((res) => {
          if (res.data.state === 'completed') {
            if (this.loading === true) {
              location.reload(true);
            }
            this.loading = false;
          } else if (res.data.state === 'executing') {
            this.loading = true;
            setTimeout(this.checkSync, TIMEOUT);
          }
        });
    },
  },
  mounted() {
    this.checkSync();
  },
};
</script>
