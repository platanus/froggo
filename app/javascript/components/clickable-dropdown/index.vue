<template>
  <dropdown ref="parentDropdown" class="select">
    <div class="select__btn" slot="btn">
      <span class="select__title">
        {{ selectedItem ? selectedItem.name : noItemsMessage }}
      </span>
    </div>
    <div class="select__body" slot="body">
      <div v-if="bodyTitle" class="select-body__title">{{ bodyTitle }}</div>
      <clickable-dropdown-item
        v-for="(item, index) in items"
        @item-clicked="itemClicked"
        :key="index"
        :item="item"
        :index=index
      >
      </clickable-dropdown-item>
    </div>
  </dropdown>
</template>

<script>
import ClickableDropdownItem from './item.vue';

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
  },
  data() {
    return {
      selectedItemIndex: 0,
    };
  },
  created() {
    this.$emit('created', { selectedItem: this.selectedItem });
  },
  computed: {
    selectedItem() {
      return this.items.length > 0 ? this.items[this.selectedItemIndex] : null;
    },
  },
  methods: {
    itemClicked(event) {
      this.selectedItemIndex = event.index;
      this.$refs.parentDropdown.closeDropdown();
      this.$emit('item-clicked', event);
    },
  },
  components: {
    ClickableDropdownItem,
  },
};
</script>
