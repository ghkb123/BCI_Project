import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import "hardhat-deploy-ethers";
import "hardhat-deploy";
import "@symfoni/hardhat-react";
import "hardhat-typechain";
import "@typechain/ethers-v5";
import "./tasks";
require("dotenv").config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (args, hre) => {
  const accounts = await hre.ethers.getSigners();
  for (const account of accounts) {
    console.log(account.address);
  }
});

/*

task("balance", "Prints an account's balance")
    .addParam("account", "The account's address")
    .setAction(async (taskArgs) => {
        const account = web3.utils.toChecksumAddress(taskArgs.account);
        const balance = await web3.eth.getBalance(account);

        console.log(web3.utils.fromWei(balance, "ether"), "ETH");
    });

module.exports = {};
*/

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
const config: HardhatUserConfig = {
  namedAccounts: {
    deployer: {
      default: 0,
    },
    dev: {
      default: 1,
    },
  },
  react: {
    providerPriority: ["web3modal", "hardhat"],
    providerOptions: {
      walletconnect: {
        options: {
          infuraId: "95a89c3520c5483d9585205bf74b40d4",
        },
      },
    },
  },
  networks: {
    hardhat: {
      chainId: 1337,
      inject: false,
      accounts: { mnemonic: process.env.METAMASK_SEED_WORDS },
    },
    kovan: {
      // url: process.env.KOVAN_Alchemy_URL,
      url: process.env.KOVAN_URL,
      chainId: 42,
      tags: ["staging"],
      gasPrice: 20000000000,
      //gas: 250000000,
      gas: 12000000,
      gasMultiplier: 2,
      accounts: [process.env.ACCOUNT_1, process.env.ACCOUNT_2]
    },
    rinkeby: {
      // url: process.env.RINKEBY_URL,
      url: process.env.ALCHEMY_KEY,
      accounts: [process.env.ACCOUNT_1, process.env.ACCOUNT_2],
      gas: 12000000,
      gasPrice: 20000000000,
    },
  },
  solidity: {
    compilers: [
      {
        version: "0.6.12",
        settings: {
          optimizer: {
            enabled: true,
            runs: 50,
          },
        },
      },
    ],
  },
};
export default config;