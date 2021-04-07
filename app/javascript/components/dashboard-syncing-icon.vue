<template>
  <div class="loading-icon loading-icon--padded" v-if="loading"></div>
</template>

<script>
/* eslint-disable no-alert */
import organizationsApi from '../api/organizations';

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
      organizationsApi.checkSync(this.id)
        .then((res) => {
          if (res.data.data.attributes.state === 'completed') {
            if (this.loading === true) {
              location.reload(true);
            }
            this.loading = false;
          } else if (res.data.data.attributes.state === 'executing') {
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
