<template>
  <div id="app">
    <div id="nav">
      <b-navbar toggleable="lg" type="dark" class="nav-background">
        <img src ="./assets/chromostake_logo.png" height="25" width="30" class="project_logo">
        <b-navbar-brand href="">Chromastake</b-navbar-brand>

        <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

        <b-collapse id="nav-collapse" is-nav  >
          <b-navbar-nav class="ml-auto">
            <b-nav-item to="/">Home</b-nav-item>
            <b-nav-item to="/about">About</b-nav-item>
            <b-nav-item to="/betting">Betting</b-nav-item>
          </b-navbar-nav>
        </b-collapse>
      </b-navbar>

    </div>
    <router-view />
  </div>
</template>

<style lang="scss">
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
.nav-background{
  background-color:#333333;
}
.project_logo{
  margin-bottom: 7px;
}
.navbar-brand{
  color:rgb(78, 184, 131)!important;
  font-weight: bold;
}
.nav-link{
color:white!important;
font-weight: bold;
}
.navbar-dark .navbar-nav .nav-link:hover {
  color:rgb(78, 184, 131)!important;
  font-weight:bold;
}
.router-link-exact-active{
  color:rgb(78, 184, 131)!important;
}



// #nav {
//   padding: 30px;
//   a {
//     font-weight: bold;
//     color: #2c3e50;
//     &.router-link-exact-active {
//       color: #42b983;
//     }
//   }
// }
</style>
