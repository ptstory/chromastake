
<template>
  <div>
    <!-- <b-button @click="isWinner=true" variant="">Show Modal</b-button> -->

    <!--Winning Modal  -->
    <b-modal centered v-model="show=true" title="Congratulations!">
      <b-container fluid>
        <b-row>
          <b-col class="headliner">
            You Won!
            <br/>
            <span class ="money">
              {pool amount}
            </span>
          </b-col>
        </b-row>
      </b-container>
      <!-- Overrides the orginal footer -->
      <div slot="modal-footer" class="w-100">
        <!--add startBet() function  -->
        <b-button size="sm" class="float-right" @click="show=false;">
          Play Again!
        </b-button>
      </div>


    </b-modal>
  </div>


</template>

<script>
  export default {
    data() {
      return {
        show: false,
        isWinner:false

      }
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
