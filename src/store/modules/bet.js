const state = {
  value: "",
  color: "",
  selectedColors: [],
  isRunning: false,
  timeLeft: 0
};

const getters = {
  state: state => {
    return state;
  },
  getTimeLeft: state => {
    return state.timeLeft;
  },
  getSelectedColors: state => {
    return state.selectedColors;
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
  },
  setTimeLeft(state, timeLeft) {
    state.timeLeft = timeLeft;
  },
  setIsRunning(state, isRunning) {
    state.isRunning = isRunning;
  },
  addSelectedColor(state, color) {
    state.selectedColors.push(color)
  }
};

export default {
  namespaced: true,
  state,
  getters,
  // actions,
  mutations
};