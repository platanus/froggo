export default {
  methods: {
    showMessage(message) {
      this.$toasted.show(message, {
        theme: 'toasted-primary',
        position: 'top-center',
        duration: 7000,
      });
    },
  },
};

