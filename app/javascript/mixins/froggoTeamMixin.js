export default {
  methods: {
    deleteUserFromSelectedUsers(userToDelete) {
      this.selectedUsers = this.selectedUsers.filter(user => user.id !== userToDelete.id);
    },
    cleanSelectedUsers() {
      this.selectedUsers = [];
    },
  },
};
