
<template>
  <div>
    <!-- <b-button @click="isWinner=true" variant="">Show Modal</b-button> -->

    <!--Winning Modal  -->
    <b-modal centered v-model="show" title="Congratulations!">
      <b-container fluid>
        <b-row>
          <b-col class="headliner">
            You Won!
            <br/>
            Here's your new balance:
            <br/>
            <span class ="money">
              {{ fromEther(ethBalance) }}
            </span>
            <span> Ether </span>
          </b-col>
        </b-row>
      </b-container>
      <!-- Overrides the orginal footer -->
      <div slot="modal-footer" class="w-100">
        <!--add startBet() function  -->
        <!-- <b-button size="sm" class="float-right" @click="show=false; this.$router.go(0);">
          Play Again!
        </b-button> -->
      </div>


    </b-modal>
  </div>


</template>

<script>
import { mapGetters } from "vuex";

  export default {
    data() {
      return {
        show: true,
        isWinner:false

      }
    },
    computed: mapGetters({
    web3Instance: "getWeb3Instance",
    ethBalance: "getEthBalance",
  }),
  methods: {
    fromEther(value) {
      return value / 1000000000000000000;
    },
  }
  }
</script>
<style>
.modal-title{
  margin-bottom: 0;
  line-height: 1.5;
  color: green;
  font-weight: bold;
}
h5.modal-title{
  font-size: 2.25rem;
}
.headliner{
  font-weight:bold;
  font-size:xx-large;
}
.money{
  color:green;
}

</style>
