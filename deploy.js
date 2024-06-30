// scripts/deploy.js

const { ethers } = require("hardhat");

async function main() {
  // Get the contract factory
  const FundMe = await ethers.getContractFactory("FundMe");

  // Deploy the contract
  const fundMe = await FundMe.deploy();
  await fundMe.deployed();

  console.log("FundMe deployed to:", fundMe.address);
}

// Run the main function and catch errors
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
