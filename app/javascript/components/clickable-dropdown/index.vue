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
      defaut: '',
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
      return this.selectedItemIndex !== -1 ?
        this.items[this.selectedItemIndex] :
        null;
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
