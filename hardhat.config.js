require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  settings: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  },
  networks : {
    mumbai : {
      url : process.env.RPC_URL,
      chainId : 80001,
      accounts : [process.env.PVT_KEY]
    },
    /*bsc : {
      url : process.env.RPC_URL2,
      chainId : 97,
      accounts : [process.env.PVT_KEY]
    },
    goerli : {
      url : process.env.RPC_URL3,
      chainId : 5,
      accounts : [process.env.PVT_KEY]
    }*/
  },
};