# chromastake

Chromastake is a decentralized application that allows users to bet on a randomly chosen color and win ether. It is made with Vue.js, Ethereum web3.js, and Ethereum smart contracts written in Solidity.

### Prerequisites

- You will need `NodeJS` v8.9.4 or later. `NodeJS` and installation instructions can be found for all major operating systems at: `https://nodejs.org/en/download/`.

- You will need `truffle` installed globally. If you haven't done so: 

```shell
$ npm install -g truffle
```
Ensure that it was installed correctly by running:

```shell
$ truffle version
```

You should see 

```shell
Truffle v5.0.7 (core: 5.0.7)
Solidity v0.5.0 (solc-js)
```

- You will need the Chrome extension `MetaMask` to handle your Ethereum wallet. It can be found at: `https://metamask.io/`.

- You will need `Ganache` to have access to a local blockchain for testing. It can be found at: `https://truffleframework.com/ganache`.

### Installing

- Clone this repo to your local machine using `https://github.com/ptstory/chromastake.git`
- Note that the `node_modules` folder is not included in the repo, so you will need to install the dependencies from the included `package.json`.

After cloning the repo, navigate to the directory containing `package.json` and run:

```shell
$ npm install
```

Once the dependencies have been installed, navigate to the directory containing `truffle-config.js` and run:

```shell
$ truffle version
```

You should see 

```shell
Truffle v5.0.7 (core: 5.0.7)
Solidity v0.5.0 (solc-js)
```

## Using the program

1. Launch Ganache - this will start up a local blockchain for you to point MetaMask to.
2. Run `truffle migrate --reset` to compile the contracts and replace the JSON build files.
3. [OPTIONAL] If you intend to store your account address as an environment variable for security, replace the env variable in the .env file with the account address printed by Truffle in your terminal. Otherwise, you must rely on web3 to fetch your account address.

![Image of account address fetched by web3](images/web3_fetch.png?raw=true)

![Image of account address printed by Truffle](images/account_address.png?raw=true)

4. Open the MetaMask extension and import the wallet produced by Ganache by pasting the mnemonic into MetaMask
![Image of mnemonic in Ganche](images/ganache_mnemonic.png?raw=true)
![Image of mnemonic imported into MetaMask](images/import_mnemonic.png?raw=true)

5. Switch from the default mainnet to http://127.0.0.1:7545 in MetaMask. Note: this address must match the one shown in Ganache.
![Image of network in Ganache](images/ganache_network.png?raw=true)
![Image of network in MetaMask](images/metamask_network.png?raw=true)

6. Run `npm run serve`.
7. View the app in your browser at at `localhost:8080`.

## Authors

* **Perry Story** - (https://github.com/ptstory)
* **Edwin Aramburo** - (https://github.com/earamburo)
* **Nicole Grizzle** - (https://github.com/thirdlight)
* **Harsha Goli** - (https://github.com/arshbot)
* **Brittney Hill** - (https://github.com/)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Dr. Juan Banda for the assignment
* Learning materials used: https://github.com/marlowl/vue-voting-dapp, https://github.com/jmbanda/CSC4890_election_dapp, and countless Ethereum Stack Exchange questions