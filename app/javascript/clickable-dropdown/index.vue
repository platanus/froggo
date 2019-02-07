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
        :text="item.name"
        :index=index
      >
      </clickable-dropdown-item>
    </div>
  </dropdown>
</template>

<script>
import ClickableDropdownItem from './item.vue';

/*
 * Dropdown with select-like items.
 * Uses Froggo's styles.
 */
export default {
  props: {
    bodyTitle: String,
    /*
     * Contains the data that will be used to render
     * each option in the dropdown. Shape is as follows:
     * [
     *   {
     *     name: 'First item's displayed name',
     *   },
     *   {
     *     name: 'Second item's displayed name',
     *   }
     * ]
     */
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
  computed: {
    selectedItem() {
      return this.items.length > 0 ? this.items[this.selectedItemIndex] : null;
    },
  },
  methods: {
    itemClicked(itemIndex) {
      this.selectedItemIndex = itemIndex;
      this.$refs.parentDropdown.closeDropdown();
    },
  },
  components: {
    ClickableDropdownItem,
  },
};
</script>
