/** @type import('hardhat/config').HardhatUserConfig */
require("@nomiclabs/hardhat-waffle");
require("dotenv").config()


module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {},
    goerli: {
      url: process.env.WEB3_PROVIDER,
      accounts: [process.env.PRIVATE_KEY]
    }
  },
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 40000
  }
};
