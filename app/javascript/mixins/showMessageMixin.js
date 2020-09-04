export default {
  methods: {
    showMessage(message) {
      this.$toasted.show(message, {
        theme: 'toasted-primary',
        position: 'top-right',
        duration: 7000,
      });
    },
  },
};

