<template>
  <div>
    <div v-if="user.tracked" v-on:click="untrack()" class="card-extended__button card-extended__button--inactive">untrack</div>
    <div v-else v-on:click="track()" class="card-extended__button">track</div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data: function () {
    return {
      user: this.value,
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
      this.user.tracked = status;

      axios.put(`/api/organization_memberships/${this.user.id}`, { tracked: status })
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
