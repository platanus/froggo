<template>
  <div>
    <div>{{ repository.name }} - {{ repository.last_update }} </div>
    <button v-if="repository.tracked" v-on:click="untrack()">destrackear</button>
    <button v-else v-on:click="track()">trackear</button>
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
