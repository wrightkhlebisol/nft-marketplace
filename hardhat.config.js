require("@nomiclabs/hardhat-waffle");
const projectId = process.env.INFURA_PROJECT_ID;
const fs = require('fs');
const privateKey = fs.readFileSync('./.secret', {
  encoding: 'utf-8', flag: 'r'
});

console.log(privateKey);


module.exports = {
  defaultNetwork: 'hardhat',
  networks: {
    hardhat: {
      chainId: 1337
    },
    mumbai: {
      url: `https://polygon-mumbai.infura.io/v3/${projectId}`,
      accounts: [privateKey]
    },
    mainnet: {
      url: `https://polygon-mainnet.infura.io/v3/${projectId}`,
      accounts: [privateKey]
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
