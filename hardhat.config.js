require("dotenv").config();

require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require("solidity-coverage");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  defaultNetwork: "ropsten",
  networks: {
    hardhat: {
      allowUnlimitedContractSize: false
    },
    kccTest: {
      url: 'https://rpc-testnet.kcc.network',
      chainId: 322,
      accounts: [process.env.PRIVATE_KEY]
      // gasPrice: 20000000000,
      // accounts: {mnemonic: mnemonic}
    },
    ropsten: {
      // b118021551b14caeb16fcc622b24b130 为项目id，在 https://infura.io 上申请
      url: "https://ropsten.infura.io/v3/b118021551b14caeb16fcc622b24b130",
      from: "0x67F035CA9ba9eCE6A0cB068d7829ACA71cdd15A6",
      chainId: 3,
      // accounts 为账户私钥，可以添加多个
      accounts : [process.env.PRIVATE_KEY]
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
  },
  etherscan: {
    apiKey: {
      // 以太坊测试网 的key，在主网上申请，他们通用
      ropsten: process.env.ETHERSCAN_KEY,
      kccTest: ''
    },
    customChains: [
      {
        network: "kccTest",
        chainId: 322,
        urls: {
          apiURL: "https://rpc-testnet.kcc.network",
          browserURL: "https://scan-testnet.kcc.network"
        }
      }
    ]
  }
};
