require("dotenv").config();

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    // development: {
    //   host: "54.175.3.251",
    //   port: 8545,
    //   network_id: "*" // Match any network id
    // }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
};
