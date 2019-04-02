<template>
  <dropdown ref="parentDropdown" class="select">
    <div class="select__btn" slot="btn">
      <span class="select__title">
        {{ selectedItem ? selectedItem.name : noItemsMessage }}
      </span>
    </div>
    <div class="select__body" slot="body">
      <div v-if="bodyTitle" class="select-body__title">{{ bodyTitle }}</div>
        <div
          v-for="(item, index) in items"
          class="select__option"
          @click="itemClicked({ item, index })"
          :key="index"
        >
          {{ item.name }}
        </div>
    </div>
  </dropdown>
</template>

<script>
export default {
  props: {
    bodyTitle: String,
    noItemsMessage: {
      type: String,
      default: '',
    },
    items: {
      type: Array,
      default() {
        return [];
      },
    },
    defaultIndex: {
      type: Number,
      default: 0,
    },
  },
  data() {
    return {
      selectedItemIndex: this.defaultIndex,
    };
  },
  computed: {
    selectedItem() {
      if (this.items === null) {
        return 0;
      }

      return this.items[this.selectedItemIndex];
    },
  },
  methods: {
    itemClicked(event) {
      this.selectedItemIndex = event.index;
      this.$refs.parentDropdown.closeDropdown();
      this.$emit('item-clicked', event);
    },
  },
};
</script>
