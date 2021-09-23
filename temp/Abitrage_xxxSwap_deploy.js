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
  const Abitrage_xxxSwap = await ethers.getContractFactory("Abitrage_xxxSwap");
  console.log('Deploying Abitrage_xxxSwap ...');
  const xxxSwap = await Abitrage_xxxSwap.deploy();
  await xxxSwap.deployed();
  console.log('Abitrage_xxxSwap deployed to:', xxxSwap.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.log("Failed deployment");
    console.error(error);
    process.exit(1);
  });