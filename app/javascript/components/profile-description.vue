<template>
  <div>
    <div
      v-if="user.description"
      class="profile-info__description"
    >
      <div
        v-if="!readMoreActivated && !editDescription"
      >
        <p
          class="profile-info__user-description"
          @dblclick="edit"
        >
          {{ user.description.slice(0,160) }} ...
        </p>
        <button
          @click="activateReadMore"
          class="btn-description"
        >
          Ver más
        </button>
      </div>
      <div
        v-if="readMoreActivated && !editDescription"
      >
        <p
          @dblclick="edit"
          class="profile-info__user-description"
          v-html="this.user.description"
        />
        <button
          v-if="user.description.length>160"
          @click="deactivateReadMore"
          class="btn-description"
        >
          Ver menos
        </button>
      </div>
      <p
        v-if="error"
        class="error"
      >
        Error: {{ this.errors }}
      </p>
      <textarea
        v-if="editDescription"
        name="description"
        type="text"
        class="input-description"
        v-model="form.description"
      />
      <input
        v-if="editDescription"
        type="submit"
        class="btn-description"
        @click="submit"
        value="Guardar"
      >
      <input
        v-if="editDescription"
        type="submit"
        class="btn-description"
        @click="cancel"
        value="Cancelar"
      >
    </div>

    <div
      v-else-if="user.id == githubSession.user.id"
      class="profile-info__description"
    >
      <p
        v-if="error"
        class="error"
      >
        Error: {{ this.errors }}
      </p>
      <textarea
        name="description"
        type="text"
        placeholder="Agrega una descripción de máximo 255 carácteres...."
        class="input-description"
        v-model="form.description"
      />
      <input
        type="submit"
        class="btn-description"
        @click="submit"
        value="Guardar"
      >
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {

  props: {
    githubUser: {
      type: Object,
      required: true,
    },
    githubSession: {
      type: Object,
      required: true,
    },
  },

  methods: {
    activateReadMore() {
      this.readMoreActivated = true;
    },
    deactivateReadMore() {
      this.readMoreActivated = false;
    },
    submit() {
      axios.patch(`/api/github_users/${String(this.githubUser.id)}`, this.form)
        // eslint-disable-next-line max-statements
        .then((res) => {
          this.user = res.data.user;
          this.error = false;
          this.form.description = this.user.description;
          this.readMoreActivated = this.user.description.length <= this.maxLength;
          this.editDescription = false;
        }).catch(() => {
          this.error = true;
          this.errors = 'Descripción muy larga máximo 255 caracteres';
        });
    },
    edit() {
      if (this.user.id === this.githubSession.user.id) {
        this.editDescription = true;
      }
    },
    cancel() {
      this.form.description = this.user.description;
      this.editDescription = false;
      this.error = false;
    },
  },
  data() {
    const init = {
      user: this.githubUser,
      editDescription: false,
      form: {
        description: '',
      },
      readMoreActivated: true,
      errors: '',
      maxLength: 160,
      error: false,
    };
    if (this.githubUser.description) {
      if (this.githubUser.description.length > init.maxLength) {
        init.readMoreActivated = false;
      }
      init.form.description = init.user.description;
    }

    return {
      ...init,
    };
  },
};
</script>
