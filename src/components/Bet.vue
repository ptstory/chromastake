<template>
  <div class="container">
    <h1>This is the bet page</h1>
    <b-button @click="startBet">Start Bet</b-button>
    <br><br>
    <p v-if="running">Running</p>
    <!-- <h4>Here is the value stored on the blockchain: {{ currentValue }}</h4>
    <b-form-input v-model="contractValue" placeholder="Enter value"></b-form-input>
    <h4>{{ loading }}</h4>
    <br>
    <b-button @click="setValue">Update</b-button>
    <br><br> -->
    <h4>Balance: {{ formatPrice(ethBalance) }}</h4>
    <h4>Address: {{ ethAddress }}</h4>
    <h4>Vuex store: {{ this.$store.state.bet.value }}</h4>
  </div>
</template>

<script>
import Web3 from "web3";
import { mapGetters } from "vuex";

import Betting from "@/../build/contracts/Betting.json";

export default {
  data() {
    return {
      contractValue: "",
      contractJson: Betting,
      currentValue: "",
      isValueUpdated: false,
      loading: "",
      running: false,
    };
  },
  computed: mapGetters({
    web3Instance: "getWeb3Instance",
    ethBalance: "getEthBalance",
    ethAddress: 'getEthAddress'
  }),
    betValue() {
        return this.$store.state.bet.value
    },
  methods: {
    initWeb3: () => {
    if (window.ethereum) {
		window.web3 = new Web3(ethereum);
        try {
          ethereum.enable();
        } catch (err) {
          alert('user denied access to metamask')
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
    // async setValue() {
    //   this.loading = "Transaction request is being processed";
    //   web3 = new Web3(web3.currentProvider);
    //   let deployedAddress = await this.getContractAddress();
    //   let myContract = new web3.eth.Contract(
    //     this.contractJson.abi,
    //     deployedAddress
    //   );
    //   let setValue = await myContract.methods
    //     .set(this.contractValue)
    //     .send({
    //       from: process.env.VUE_APP_ETHADDRESS
    //     })
    //     .then(this.$store.commit("bet/setValue", this.contractValue))
    //     .catch(error => alert(error.message));

    //   if (setValue) {
    //     this.loading = "";
    //     this.isValueUpdated = true;
    //   }
    // },
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
    this.getAccount()
    this.getRunning()

  }
};
</script>

<style scoped lang="scss"></style>
