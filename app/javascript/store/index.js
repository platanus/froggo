import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex';

import profile from './modules/profile';
import preferences from './modules/preferences';
import recommendations from './modules/recommendations';
import scores from './modules/scores';
import admin from './modules/admin';
import froggoTeam from './modules/froggo_team';

import { SET_CURRENT_USER } from './mutation-types';

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    profile,
    preferences,
    recommendations,
    scores,
    admin,
    froggoTeam,
  },
  state: {
    currentUser: null,
  },
  mutations: {
    [SET_CURRENT_USER](state, user) {
      state.currentUser = user;
    },
  },
});
