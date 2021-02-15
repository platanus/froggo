<template>
  <div class="profile-team-tags-table">
    <table
      class="profile-team-tags-table__table"
    >
      <thead class="profile-team-tags-table__header">
        <tr>
          <th class="profile-team-tags-table__column-head">
            <div class="profile-team-tags-table__column-head-content ">
              {{ $i18n.t('message.profile.tagsTable.user') }}
              <input
                class="profile-team-tags-table__input-user"
                type="text"
                :placeholder="$i18n.t('message.profile.tagsTable.userFilterMessage')"
                :value="userFilter"
                @input="handleUserInput"
              >
            </div>
          </th>
          <th class="profile-team-tags-table__column-head">
            <div class="profile-team-tags-table__column-head-content ">
              {{ $i18n.t('message.profile.tagsTable.color') }}
              <color-multi-select
                :items="colorOptions"
                @color-clicked="onColorClicked"
              />
            </div>
          </th>
          <th class="profile-team-tags-table__column-head">
            <div
              ref="tagsHeader"
              class="profile-team-tags-table__column-head-content "
            >
              <span ref="tagsTitle">
                {{ $i18n.t('message.profile.tagsTable.tags') }}
              </span>
              <clickable-dropdown
                :no-items-message="$i18n.t('message.profile.tagsTable.dropdownAll')"
                :items="tags"
                :default-index="-1"
                :all-option="$i18n.t('message.profile.tagsTable.dropdownAll')"
                :white-mode="true"
                :width="selectTagsWidth"
                @item-clicked="onTagClicked"
                ref="dropdownTags"
              />
            </div>
          </th>
          <th class="profile-team-tags-table__column-head">
            <div class="profile-team-tags-table__column-head-content ">
              {{ $i18n.t('message.profile.tagsTable.description') }}
            </div>
          </th>
        </tr>
      </thead>
      <tbody
        class="profile-team-tags-table__body"
      >
        <tr
          v-for="(user, index) in filteredTeam"
          :key="user.id"
        >
          <td>
            <a
              class="profile-team-tags-table__user"
              :href="`/users/${user.id}`"
            >
              <img
                class="profile-team-tags-table__picture"
                :src="user.avatar_url"
              >
              <div class="profile-team-tags-table__username">
                {{ user.login }}
              </div>
            </a>
          </td>
          <td>
            <div
              :class="`profile-team-tags-table__color-badge
              profile-team-tags-table__color-badge--${colorFromScore(user.score)}`"
            />
          </td>
          <td>
            <div :ref="`tags${user.id}`">
              <team-tags
                :tags="user.tags"
                :index="index"
              />
            </div>
          </td>
          <td class="profile-team-table ">
            <div
              class="profile-team-tags-table__description"
              :style="{ height: `max(${rowHeight(user.id)}px, 56px)`}"
            >
              {{ user.description }}
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
<script>
import teamTags from './team-tags.vue';
import colorFromScore from '../../helpers/color-from-score.js';
import clickableDropdown from '../clickable-dropdown';
import colorMultiSelect from '../color-multi-select';

export default {
  data() {
    return {
      colorOptions: [
        { 'name': 'red' },
        { 'name': 'light-red' },
        { 'name': 'green' },
        { 'name': 'light-blue' },
        { 'name': 'blue' }],
      selectedColors: {
        'red': true,
        'light-red': true,
        'green': true,
        'light-blue': true,
        'blue': true },
      selectedTag: null,
      userFilter: '',
      maxRowHeight: {},
      selectTagsWidth: 0,
    };
  },
  components: { teamTags, clickableDropdown, colorMultiSelect },
  mounted() {
    const newMaxRowHeight = {};
    this.team.forEach((user) => {
      const userTags = this.$refs[`tags${user.id}`][0];
      newMaxRowHeight[user.id.toString()] = userTags && userTags.clientHeight;
    });
    this.maxRowHeight = newMaxRowHeight;
    this.selectTagsWidth = this.$refs.tagsHeader.clientWidth - this.$refs.tagsTitle.clientWidth;
  },
  props: {
    team: {
      type: Array,
      default: () => [],
    },
    tags: {
      type: Array,
      required: true,
    },
  },
  methods: {
    colorFromScore,
    onColorClicked(event) {
      this.selectedColors[event.color] = !this.selectedColors[event.color];
      this.selectedColors = Object.assign({}, this.selectedColors);
    },
    onTagClicked(event) {
      if (event.index < 0) {
        this.selectedTag = null;
      } else {
        this.selectedTag = this.tags[event.index].name;
      }
    },
    rowHeight(userId) {
      return this.maxRowHeight[userId.toString()];
    },

    handleUserInput(event) {
      this.userFilter = event.target.value.toLowerCase().trim();
    },
  },
  computed: {
    tagsIds() {
      return (this.tags.map((tag) => (tag.id)));
    },
    tagsNames() {
      return (this.tags.map((tag) => (tag.id)));
    },
    filteredTeam() {
      let team = [];
      team = this.team.filter((user) => (user.login.toLowerCase().includes(this.userFilter)));
      team = team.filter((user) => (this.selectedColors[colorFromScore(user.score)]));
      if (this.selectedTag) {
        team = team.filter((user) => (user.tags.map((tag) => (tag.name)).includes(this.selectedTag)));
      }

      return team;
    },
  },
};
</script>
