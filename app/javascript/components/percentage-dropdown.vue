<template>
  <dropdown
    ref="parentDropdown"
    class="dropdown"
  >
    <div
      class="dropdown__btn"
      slot="btn"
      v-tooltip="tooltipMessage()"
    >
      <span class="dropdown__title">
        {{ selectedItem ? selectedItem+'%' : noItemsMessage }}
      </span>
    </div>
    <div
      class="dropdown__body"
      slot="body"
    >
      <div
        v-if="bodyTitle"
        class="dropdown-body__title"
      >
        {{ bodyTitle }}
      </div>
      <div
        v-for="(item, index) in items"
        class="dropdown__option"
        @click="itemClicked(item)"
        :key="index"
      >
        {{ item+'%' }}
      </div>
    </div>
  </dropdown>
</template>

<script>
export default {
  props: {
    user: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      bodyTitle: this.$i18n.t('message.froggoTeams.percentageDropdownTitle'),
      items: ['20', '40', '50', '60', '80', '100'],
      selectedPercentage: this.user.percentage,
      noItemsMessage: '',
    };
  },
  computed: {
    selectedItem() {
      return this.selectedPercentage;
    },
  },
  methods: {
    itemClicked(item) {
      this.selectedPercentage = item;
      this.$refs.parentDropdown.closeDropdown();
      const newPercentage = parseInt(item, 10);
      this.user.percentage = newPercentage;
    },
    tooltipMessage() {
      const currentPercentage = parseInt(this.user.percentage, 10);
      const hundredPercent = 100;
      if (currentPercentage < hundredPercent) {
        return this.$i18n.t('message.froggoTeams.increasePercentageMessage');
      }

      return null;
    },
  },
};
</script>
