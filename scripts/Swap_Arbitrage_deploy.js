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
  const KBAbitrage = await ethers.getContractFactory("KBAbitrage");
  console.log('Deploying KBAbitrage ...');
  const kbAbitrage = await KBAbitrage.deploy();
  await kbAbitrage.deployed();
  console.log('KBAbitrage deployed to:', kbAbitrage.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.log("Failed deployment");
    console.error(error);
    process.exit(1);
  });