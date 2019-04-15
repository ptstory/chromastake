<template>
  <!-- <b-container class="">
    <b-row class="">
      <b-col>Please choose a color:
      <swatches v-model="color" :colors="colors" row-length="5"></swatches>
      </b-col>
    </b-row>
  </b-container> -->
  <b-container fluid v-if="running" class ="running_page">
    <b-container class = "input_container">
      <b-row>
        <b-col><span style="color:black;font-weight:bold;">Place Bet</span><b-form-input v-model="colorSelected" placeholder="$$$$$$"></b-form-input></b-col>
        <b-col><span style="color:black;font-weight:bold;">Select color:</span>
        <swatches v-model="color" :colors="colors" row-length="5"></swatches></b-col>
        <b-col><span style="color:black;font-weight:bold;">Pool Amount</span><b-form-input v-model="betValue" placeholder="Pool Amount"></b-form-input></b-col>
      </b-row>
      <span>{{color}}</span>
    </b-container>
    <b-container class ="animation_container">
    </b-container>
    <!-- <b-container class="loader"> -->
    <b-container class="footer">
      <b-row>
        <b-col>Balance: {{ formatPrice(ethBalance) }}</b-col>
        <b-col><b-button @click="makeBet">Make Bet</b-button></b-col>
        <b-col>Address: {{ ethAddress }}<br>Vuex store: {{ this.$store.state.bet.color }}</b-col>
      </b-row>
    </b-container>

    <!-- </b-container> -->
    <!-- <b-container class="footer_container">
      <b-row align-v="end">
        <b-col>Balance: {{ formatPrice(ethBalance) }}</b-col>
        <b-col>Address: {{ ethAddress }}</h4></b-col>
        <b-col>Vuex store: {{ this.$store.state.bet.color }}</b-col>
      </b-row>
    </b-container>-->
  </b-container>

  <b-container fluid v-else>
    <b-row class ="button_page" align-v="center">
      <b-col></b-col>
      <b-col><b-button size="lg" variant="dark" @click="startBet">Play!</b-button></b-col>
      <b-col></b-col>
    </b-row>
  </b-container>


    <!-- <br>
    <br>
    <p v-if="running">Running</p>
    <br>
    <br> -->


    <!-- <b-button @click="makeBet">Make Bet</b-button>
    <br>
    <br>
    <h4>Balance: {{ formatPrice(ethBalance) }}</h4>
    <h4>Address: {{ ethAddress }}</h4>
    <h4>Vuex store: {{ this.$store.state.bet.color }}</h4> -->
  <!-- </b-container>
  <b-container fluid v-else >
    <b-row class ="button_page" align-v="center">
      <b-col></b-col>
      <b-col><b-button size="lg" variant="dark" @click="startBet">Play!</b-button></b-col>
      <b-col></b-col>
    </b-row>
  </b-container> -->

    <!-- <h1>This is the bet page</h1>
    <b-button @click="startBet">Start Bet</b-button> -->




</template>
<style scoped>
.button_page{
  width:100vw;
  height:94vh;
  background-color:#37775c;
  padding-bottom:56px;
}
.running_page{
  width:100vw;
  height:94vh;
  /* background-color:#37775c; */

}
.input_container{
  padding:35px;
  /* background-color:#37775c; */
}
.animation_container{
  height:66%;

}
/* LOADER */
.loader,.loader:before,.loader:after{
    top:0;
    bottom:0;
    left:0;
    right:0;
    content:"";
    position:absolute;
    border-radius:50%;
  }

  .loader{
    position:fixed;
    width:100px;
    height:100px;
    margin:auto;
    animation:spin 4s linear infinite;
  }

  @keyframes spin{
    100%{transform:rotate(360deg);filter:hue-rotate(360deg)}
  }

  .loader:before{
    border:5px solid #aaa;
    border-bottom:5px solid orange;
    border-left:5px solid orange;
    animation:spin1 1s linear infinite;
  }

  .loader:after{
    border:5px solid #aaa;
    border-top:5px solid transparent;
    border-right:5px solid transparent;
    animation:spin2 1s linear infinite;
  }

  @keyframes spin1{
    20%{transform:rotate(90deg)}
    40%{transform:rotate(90deg)}
    80%{transform:rotate(90deg)}
    100%{transform:rotate(90deg)}
  }
  @keyframes spin2{
    0%{transform:rotate(-30deg)}
    20%{transform:rotate(-30deg);
        border-color:transparent transparent #aaa #aaa}
    21%{border-color:orange orange transparent transparent}
    40%{transform:rotate(-30deg)}
    60%{transform:rotate(120deg);
        border-color:orange orange transparent transparent}
    61%{border-color:transparent transparent #aaa #aaa}
    80%{transform:rotate(270deg)}
    100%{transform:rotate(330deg);}
  }
/*LOADER  */

.footer{
  overflow:hidden;


}


</style>

<script>
import Web3 from "web3";
import { mapGetters } from "vuex";
import Swatches from 'vue-swatches'


import Betting from "@/../build/contracts/Betting.json";
import "vue-swatches/dist/vue-swatches.min.css";

export default {
  components: { Swatches },
  data() {
    return {
      color: '',
      colors: [
        ['#f7931e', '#2e3192', '#22b573', '#c1272d', '#662d91', '#56c6d0' ],
      ],
      colorSelected: "",
      betValue: 0,
      contractJson: Betting,
      currentValue: "",
      isValueUpdated: false,
      loading: "",
      running: false
    };
  },
  computed: mapGetters({
    web3Instance: "getWeb3Instance",
    ethBalance: "getEthBalance",
    ethAddress: "getEthAddress"
  }),
  betValue() {
    return this.$store.state.bet.value;
  },
  methods: {
    initWeb3: () => {
      if (window.ethereum) {
        window.web3 = new Web3(ethereum);
        try {
          ethereum.enable();
        } catch (err) {
          alert("user denied access to metamask");
        }
      }
    },

    async getContractAddress() {
      web3 = new Web3(web3.currentProvider);
      let networkID = await web3.eth.net.getId();
      // let networkID = 5777 //hard code this for now as getId() isn't working
      let deployedAddress = this.contractJson.networks[networkID].address;
      return deployedAddress;
    },
    async getAccount() {
      web3 = new Web3(web3.currentProvider);
      web3.eth.getAccounts().then(console.log);
    },
    async makeBet() {
      web3 = new Web3(web3.currentProvider);
      let deployedAddress = await this.getContractAddress();
      let myContract = new web3.eth.Contract(
        this.contractJson.abi,
        deployedAddress
      );
      let makeBet = await myContract.methods
        .makeBet(this.colorSelected)
        .send({
          value: this.toEther(this.betValue),
          from: process.env.VUE_APP_ETHADDRESS
        })
        .then(this.$store.commit("bet/setColor", this.colorSelected))
        .catch(error => alert(error.message));
    },
    async getRunning() {
      web3 = new Web3(web3.currentProvider);
      let deployedAddress = await this.getContractAddress();
      let myContract = new web3.eth.Contract(
        this.contractJson.abi,
        deployedAddress
      );
      let getRunning = await myContract.methods.getRunning().call();
      this.running = getRunning;
    },
    async startBet() {
      this.loading = "Transaction request is being processed";
      web3 = new Web3(web3.currentProvider);
      let deployedAddress = await this.getContractAddress();
      let myContract = new web3.eth.Contract(
        this.contractJson.abi,
        deployedAddress
      );
      let startBet = await myContract.methods
        .startBet(100)
        .send({
          from: process.env.VUE_APP_ETHADDRESS
        })
        // .then(this.$store.commit("bet/setValue", this.contractValue))
        // .then(this.running = this.getRunning())
        .catch(error => alert(error.message));

      if (setValue) {
        this.loading = "";
        this.isValueUpdated = true;
      }
    },
    formatPrice(value) {
      return value && value !== 0
        ? web3Instance.utils.fromWei(value, "ether") + " ether"
        : "-";
    },
    toEther(value) {
      return value * 1000000000000000000;
    }
  },
  watch: {
    // isValueUpdated: function(newValue, oldValue) {
    //   if (newValue == true) {
    //     window.location.reload(true);
    //   }
    // }
    // betValue() {
    //   alert("value changed");
    // }
  },
  created: function() {
    window.addEventListener("load", () => {
      setTimeout(() => {
        this.$store.dispatch("fetchWeb3Instance");
      }, 100);
    });
    this.initWeb3();
    // this.getCurrentValue();
    this.getAccount();
    this.getRunning();
  }
};
</script>
