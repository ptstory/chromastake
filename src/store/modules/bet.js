const state = {
  value: ""
};

const getters = {
  state: state => {
    return state;
  }
};

// const actions = {
//   getValue({ commit }) {
//     value => {
//       commit("setValue", value);
//     };
//   }
// };

const mutations = {
  setValue(state, value) {
    state.value = value;
  }
};

export default {
  namespaced: true,
  state,
  getters,
  // actions,
  mutations
};
