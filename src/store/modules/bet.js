const state = {
  value: "",
  color: ""
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
  },
  setColor(state, color) {
    state.color = color;
  }
};

export default {
  namespaced: true,
  state,
  getters,
  // actions,
  mutations
};
