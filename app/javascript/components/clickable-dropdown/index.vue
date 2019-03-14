<template>
  <dropdown ref="parentDropdown" class="select">
    <div class="select__btn" slot="btn">
      <span class="select__title">
        {{ selectedItem ? selectedItem.name : noItemsMessage }}
      </span>
    </div>
    <div class="select__body" slot="body">
      <div v-if="bodyTitle" class="select-body__title">{{ bodyTitle }}</div>
      <dropdown v-for="(item, org_index) in items" v-if="item.login" class="select">
        <div class="select__btn" slot="btn">
          <span class="select-body__title">
            {{ item.login }}
          </span>
        </div>
        <div class="select__body" slot="body">
          <div
            v-for="(item, index) in items" v-if="item.name && index > org_index && index < nextOrgIndex(org_index)"
            class="select__option"
            @click="itemClicked({ item, index })"
            :key="index"
          >
            {{ item.name }}
          </div>
        </div>
      </dropdown>
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
      return this.items[this.selectedItemIndex]; // Could be `undefined`.
    },
  },
  methods: {
    itemClicked(event) {
      this.selectedItemIndex = event.index;
      this.$refs.parentDropdown.closeDropdown();
      this.$emit('item-clicked', event);
    },
    nextOrgIndex(org_index) {
      for (var i = org_index + 1; i < this.items.length; i++) {
        if (this.items[i].login){
          return i
        };
      };
      return this.items.length
    },
  },
};
</script>
