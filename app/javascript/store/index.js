import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex';

import profile from './modules/profile';
import scores from './modules/scores';
import statistics from './modules/statistics';
import admin from './modules/admin';

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    profile,
    scores,
    statistics,
    admin,
  },
});
