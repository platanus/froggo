<template>
  <div>
    <div v-if="repository.tracked" v-on:click="untrack()" class="card-extended__button card-extended__button--inactive">untrack</div>
    <div v-else v-on:click="track()" class="card-extended__button">track</div>
    <div class="card-extended__repo-name">{{ repository.name }} - {{ repository.last_update }}</div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data: function () {
    return {
      repository: this.value,
    }
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

      axios.put(`/api/repositories/${this.repository.id}`, { tracked: status })
        .then(function (response) {
          console.log(response);
        })
        .catch(function (error) {
          console.log(error);
        });
    }
  },
}
</script>
