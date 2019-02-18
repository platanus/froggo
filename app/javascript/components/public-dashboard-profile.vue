<template>
  <div class="pd-card">
    <div class="pd-card__upper-half">
      <div class="profile__picture">
        <img :src=imageUrl>
      </div>
      <div class="profile__github-info">
        <a :href="githubUrl">
          <div class="profile__link">
            <div class="profile__link-icon">
              icon |
            </div>
            <div>
              @{{ githubLogin }}
            </div>
          </div>
        </a>
      </div>
    </div>
    <div class="pd-card__lower-half">
      <div class="pd-card__number-container">
        <div class="pd-card__number">
          130
        </div>
        <div class="pd-card__text">
          puntaje esta semana
        </div>
      </div>
      <div class="pd-card__number-container">
        <div class="pd-card__number">
          + 38%
        </div>
        <div class="pd-card__text">
          diferencia semana anterior
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    userId: String,
    githubLogin: {
      type: String,
      default: '??',
    },
    imageUrl: {
      type: String,
      default: 'https://avatars2.githubusercontent.com/u/66601?s=88&v=4',
    },
  },
  computed: {
    githubUrl() {
      return `https://github.com/${this.githubLogin}`;
    }
  },
}
</script>
