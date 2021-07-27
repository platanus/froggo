import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex';

import profile from './modules/profile';
import preferences from './modules/preferences';
import recommendations from './modules/recommendations';
import scores from './modules/scores';
import admin from './modules/admin';
import froggoTeam from './modules/froggo_team';

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
});
