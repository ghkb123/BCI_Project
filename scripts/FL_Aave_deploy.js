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
  const MyV2FlashLoan = await ethers.getContractFactory("MyV2FlashLoan");
  console.log('Deploying MyV2FlashLoan ...');
  const FL = await MyV2FlashLoan.deploy("0x88757f2f99175387aB4C6a4b3067c77A695b0349");
  await FL.deployed();
  console.log('MyV2FlashLoan deployed to:', FL.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.log("Failed deployment");
    console.error(error);
    process.exit(1);
  });