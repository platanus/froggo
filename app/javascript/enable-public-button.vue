<template>
  <div v-if="enabled" v-on:click="toggle()" class="button button--light">Deshabilitar dashboard público</div>
  <div v-else v-on:click="toggle()" class="button">Habilitar dashboard público</div>
</template>

<script>
import axios from 'axios';

export default {
  props: ['organization'],
  data() {
    return {
      enabled: this.organization.public_enabled,
      id: this.organization.id,
    };
  },
  methods: {
    toggle() {
      axios.put(`/api/organizations/${this.id}/update_public_enabled`,
        { 'public_enabled': !this.enabled })
        .then(() => {
          this.enabled = !this.enabled;
        })
        .catch((error) => {
          console.log(error);
        });
    },
  },
};
</script>
