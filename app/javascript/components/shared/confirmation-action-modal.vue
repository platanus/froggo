<template>
  <div class="flex flex-col w-full py-3">
    <div class="flex justify-between px-4 pb-2 mb-5 border-b">
      <p class="">
        {{ titleMessage }}
      </p>
      <img
        class="w-5 h-5 cursor-pointer"
        :src="require('../../../assets/images/close.png').default"
        @click="closeModal"
      >
    </div>
    <p class="self-center mb-5 font-bold">
      {{ confirmationMessage }}
    </p>
    <p class="self-center mb-5">
      Esta acción es irreversible
    </p>
    <div class="flex justify-around">
      <button
        class="w-56 px-2 py-1 border rounded-md"
      >
        Cancelar
      </button>
      <button
        class="w-56 px-2 py-1 text-white bg-red-600 border rounded-md"
        @click="dispatchAction"
      >
        {{ confirmationButtonMessage }}
      </button>
    </div>
  </div>
</template>
<script>
export default {
  props: {
    titleMessage: { type: String, default() { return ''; } },
    confirmationMessage: { type: String, default() { return ''; } },
    confirmationButtonMessage: { type: String, default() { return ''; } },
    action: { type: String, default() { return ''; } },
    actionParams: { type: Array, default() { return []; } },
    redirectPath: { type: String, default() { return ''; } },
  },
  methods: {
    closeModal() {
      this.$modal.hide('confirmation-action-modal');
    },
    async dispatchAction() {
      await this.$store.dispatch(this.action, ...this.actionParams);
      window.location.href = this.redirectPath;
    },
  },
};
</script>
