require('dotenv').config();

//yarn add hardhat-waffle 
require('@nomiclabs/hardhat-waffle');
require('@nomiclabs/hardhat-etherscan');
require('hardhat-abi-exporter');
require('hardhat-docgen');
require('hardhat-gas-reporter');
require('hardhat-spdx-license-identifier');
require('solidity-coverage');
require("@nomiclabs/hardhat-waffle");

require("./tasks/deploy_stacked_toadz");
require("./tasks/deploy_stacker");
require("./tasks/deploy_staked_toadz");
require("./tasks/deploy_staked_stacked_toads");
require("./tasks/deploy_stack_rewards");
require("./tasks/set_start_stacker");
require("./tasks/stacker");
require("./tasks/set_reward_params");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 module.exports = {
  solidity: {
    version: '0.8.4',
    settings: {
      optimizer: {
        enabled: true,
        runs: 10,
      },
    },
  },

  networks: {
    hardhat: {
      ...(process.env.FORK_MODE
        ? {
            forking: {
              url: `https://eth-${
                process.env.FORK_NETWORK || 'mainnet'
              }.alchemyapi.io/v2/${process.env.ALCHEMY_KEY}`,
            },
          }
        : {}),
    },

    mainnet: {
      url: `https://eth-mainnet.alchemyapi.io/v2/${process.env.ALCHEMY_MAINNET_KEY}`,
      accounts: [process.env.ETH_MAIN_KEY],
      gas: 2900000,
      gasPrice: 120000000000
    },

    rinkeby: {
      url: `https://eth-rinkeby.alchemyapi.io/v2/${process.env.ALCHEMY_KEY}`,
      accounts: [process.env.ETH_TEST_KEY],
    },
  },

  abiExporter: {
    clear: true,
    flat: true,
    pretty: true,
  },

  docgen: {
    clear: true,
    runOnCompile: false,
  },

  etherscan: {
    apiKey: process.env.API_KEY,
  },

  gasReporter: {
    enabled: process.env.REPORT_GAS === 'true',
  },

  spdxLicenseIdentifier: {
    overwrite: false,
    runOnCompile: true,
  },
};

