<template>
  <div class="container">
    <h4>Here is the value stored on the blockchain: {{ currentValue }}</h4>
    <b-form-input v-model="contractValue" placeholder="Enter value"></b-form-input>
    <h4>{{ loading }}</h4>
    <br>
    <b-button @click="setValue">Update</b-button>
    <br><br>
    <h4>Balance: {{ formatPrice(ethBalance) }}</h4>
    <h4>Address: {{ ethAddress }}</h4>
    <h4>Vuex store: {{ this.$store.state.bet.value }}</h4>
  </div>
</template>

<script>
import Web3 from "web3";
import { mapGetters } from "vuex";

// import MyContract from "@/../build/contracts/MyContract.json";
// import MyContract from "/Users/perrystory/chromastake_js/build/contracts/MyContract.json"

export default {
  data() {
    return {
      contractValue: "",
      contractJson: MyContract,
      currentValue: "",
      isValueUpdated: false,
      loading: ""
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
    async setValue() {
      this.loading = "Transaction request is being processed";
      web3 = new Web3(web3.currentProvider);
      let deployedAddress = await this.getContractAddress();
      let myContract = new web3.eth.Contract(
        this.contractJson.abi,
        deployedAddress
      );
      let setValue = await myContract.methods
        .set(this.contractValue)
        .send({
          from: process.env.VUE_APP_ETHADDRESS
        })
        .then(this.$store.commit("bet/setValue", this.contractValue))
        .catch(error => alert(error.message));

      if (setValue) {
        this.loading = "";
        this.isValueUpdated = true;
      }
    },
    async getCurrentValue() {
      web3 = new Web3(web3.currentProvider);
      let deployedAddress = await this.getContractAddress();
      let myContract = new web3.eth.Contract(
        this.contractJson.abi,
        deployedAddress
      );
      let getValue = await myContract.methods.get().call();
      this.currentValue = getValue;
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
    this.getCurrentValue();
    this.getAccount()
  }
};
</script>

<style scoped lang="scss"></style>
