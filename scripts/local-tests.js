const hre = require("hardhat");

async function main() {
  // Get example accounts
  const [owner, acc1, acc2, acc3] = await hre.ethers.getSigners();

  // Get the contract to deploy & deploy it
  const nftContractFactory = await hre.ethers.getContractFactory(
    "ChainBattles"
  );
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();

  console.log("Contract deployed to:", nftContract.address);

  // Mint a new Warrior token
  console.log("== Minting a new Warrior token... ==");
  await nftContract.connect(owner).mintWarrior();

  // Call train function
  console.log("== Calling train function... ==");
  await nftContract.connect(owner).train(1);
  await nftContract.connect(owner).train(1);
  await nftContract.connect(owner).train(1);

  // Mint a new Mage token
  console.log("== Minting a new Warrior token... ==");
  await nftContract.connect(acc1).mintMage();

  // Call train function
  console.log("== Calling train function... ==");
  await nftContract.connect(acc1).train(2);
  await nftContract.connect(acc1).train(2);
  await nftContract.connect(acc1).train(2);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
