<template>
  <div class="profile-team-tags-table">
    <div
      v-if="beingFetched || !team"
      class="loading-icon"
    />
    <table
      v-else
      class="profile-team-tags-table__table"
    >
      <thead class="profile-team-tags-table__header">
        <tr>
          <th class="profile-team-tags-table__column-title-center ">
            {{ $i18n.t('message.profile.tagsTable.user') }}
            <input
              class="profile-team-tags-table__input-user"
              type="text"
              :placeholder="$i18n.t('message.profile.tagsTable.userFilterMessage')"
              :value="userFilter"
              @input="userFilter= $event.target.value.toLowerCase().trim()"
            >
          </th>
          <th class="profile-team-tags-table__column-title-center ">
            {{ $i18n.t('message.profile.tagsTable.color') }}
            <clickable-dropdown
              :no-items-message="$i18n.t('message.profile.tagsTable.dropdownAll')"
              :items="colorOptions"
              :default-index="-1"
              :center-mode="true"
              :color-mode="true"
              @item-clicked="onColorClicked"
            />
          </th>
          <th class="profile-team-tags-table__column-title-tags ">
            {{ $i18n.t('message.profile.tagsTable.tags') }}
            <clickable-dropdown
              :no-items-message="$i18n.t('message.profile.tagsTable.dropdownAll')"
              :items="tags"
              :default-index="-1"
              :all-option="$i18n.t('message.profile.tagsTable.dropdownAll')"
              :center-mode="true"
              :full-width-mode="true"
              @item-clicked="onTagClicked"
            />
          </th>
          <th class="profile-team-tags-table__column-title-center ">
            {{ $i18n.t('message.profile.tagsTable.description') }}
          </th>
        </tr>
      </thead>
      <tbody class="profile-team-tags-table__body">
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
            <team-tags
              :tags="user.tags"
              :index="index"
            />
          </td>
          <td>
            <div class="profile-team-tags-table__description">
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
import ClickableDropdown from '../clickable-dropdown';

export default {
  data() {
    return {
      colorOptions: [
        { 'name': 'red' },
        { 'name': 'light-red' },
        { 'name': 'green' },
        { 'name': 'light-blue' },
        { 'name': 'blue' }],
      selectedColor: null,
      selectedTag: null,
      userFilter: '',
    };
  },
  components: { teamTags, ClickableDropdown },
  props: {
    team: {
      type: Array,
      default: () => [],
    },
    beingFetched: {
      type: Boolean,
      default: true,
    },
    tags: {
      type: Array,
      required: true,
    },
  },
  methods: {
    colorFromScore,
    onColorClicked(event) {
      this.selectedColor = event.index < 0 ? null : this.colorOptions[event.index].name;
    },
    onTagClicked(event) {
      if (event.index < 0) {
        this.selectedTag = null;
      } else {
        this.selectedTag = this.tags[event.index].name;
      }
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
      if (this.beingFetched) return [];
      team = this.team.filter((user) => (user.login.toLowerCase().includes(this.userFilter)));
      if (this.selectedColor) {
        team = team.filter((user) => (colorFromScore(user.score) === this.selectedColor));
      }
      if (this.selectedTag) {
        team = team.filter((user) => (user.tags.map((tag) => (tag.name)).includes(this.selectedTag)));
      }

      return team;
    },
  },
};
</script>
