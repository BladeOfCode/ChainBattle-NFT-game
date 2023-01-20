const main = async () => {
  try {
    // Get the contract to deploy & deploy it
    const nftContractFactory = await hre.ethers.getContractFactory(
      "ChainBattles"
    );
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();

    console.log("Contract deployed to:", nftContract.address);
    process.exit(0);

  } catch (error) {
    // Handle errors
    console.log(error);
    process.exit(1);
  }
};

main();