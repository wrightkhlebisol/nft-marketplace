require("@nomiclabs/hardhat-waffle");
const projectId = '9afef0e3f2a24d4eb61a54ef4e012ce5';
const fs = require('fs');
const keyData = fs.readFileSync('./.secret', {
  encoding: 'utf-8', flag: 'r'
});

console.log(keyData);


const privateKey = '';


module.exports = {
  defaultNetwork: 'hardhat',
  networks: {
    hardhat: {
      chainId: 1337
    },
    mumbai: {
      url: `https://polygon-mumbai.infura.io/v3/${projectId}`,
      accounts: [keyData]
    },
    mainnet: {
      url: `https://polygon-mainnet.infura.io/v3/${projectId}`,
      accounts: [keyData]
    }
  },
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },

};
