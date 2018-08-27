<template>
  <div class="sync-organization" v-on:click="load()">
    <div v-if="!loading">{{ $t("message.settings.sync") }}</div>
    <div v-if="loading">{{ $t("message.settings.loading") }}</div>
  </div>
</template>

<script>
  import Spinner from 'vue-simple-spinner';
  import axios from 'axios';

  export default {
    props: ['id', 'error_msg'],
    data() {
      return {
        loading: false
      }
    },
    components: {
      Spinner
    },
    methods: {
      load() {
        if (this.loading) {
          return;
        }
        this.loading = true;
        axios.post("/api/organizations/" + this.id + "/sync")
          .then(function () {
            this.check_sync()
          }.bind(this))
          .catch(function (error) {
            alert(this.error_msg)
          }.bind(this));
      },
      check_sync() {
        axios.get("/api/organizations/" + this.id + "/check_sync")
          .then(function(res) {
            if (res.data.state == "completed") {
              this.loading = false;
            } else if (res.data.state == "failed") {
              this.loading = false;
              alert(this.error_msg)
            } else {
              setTimeout(this.check_sync(), 1000);
            }
          }.bind(this));
      }
    }
  }
</script>
