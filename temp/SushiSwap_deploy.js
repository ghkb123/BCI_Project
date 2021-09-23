// scripts/deploy.js
const { ethers, upgrades } = require('hardhat');
const fs = require('fs');

async function main() {

  const [deployer] = await ethers.getSigners();
  const chainId = await getChainId()

  console.log(
    "Deploying contracts with the account:",
    deployer.address
  );

  console.log("Account balance:", (await deployer.getBalance()).toString());

  // We get the contract to deploy
  const SushiSwap = await ethers.getContractFactory("SushiSwap");
  console.log('Deploying SushiSwap ...');
  const sushiSwap = await SushiSwap.deploy();
  await sushiSwap.deployed();
  console.log('sushiSwap deployed to:', sushiSwap.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.log("Failed deployment");
    console.error(error);
    process.exit(1);
  });