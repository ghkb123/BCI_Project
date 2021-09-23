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
  const KBSwap = await ethers.getContractFactory("KBSwap");
  console.log('Deploying KBSwap ...');
  const kbSwap = await KBSwap.deploy();
  await kbSwap.deployed();
  console.log('KBSwap deployed to:', kbSwap.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.log("Failed deployment");
    console.error(error);
    process.exit(1);
  });