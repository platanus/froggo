<template>
  <div v-if="enabled" v-on:click="toggle()" class="button button--light">{{ $t("message.settings.disablePublic") }}</div>
  <div v-else v-on:click="toggle()" class="button">{{ $t("message.settings.enablePublic") }}</div>
</template>

<script>
/* eslint-disable no-alert */
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
        .catch(() => {
          alert(this.$i18n.t('message.settings.error'));
        });
    },
  },
};
</script>
