const main = async () => {
    const MultisigTreasuryFactory = await hre.ethers.getContractFactory(
      "MultiSigTreasury"
    );
    const MultiSigTreasury = await MultisigTreasuryFactory.deploy([
      "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
      "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
      "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC",
      "0x90F79bf6EB2c4f870365E785982E1f101E93b906"
    ]);
    await MultiSigTreasury.deployed();
  
    const AccessControlFactory = await hre.ethers.getContractFactory(
      "AccessControl"
    );
    const AccessControl = await AccessControlFactory.deploy(
      MultiSigTreasury.address,
      [
      "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
      "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
      "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC",
      "0x90F79bf6EB2c4f870365E785982E1f101E93b906"
      ]
    );
    await AccessControl.deployed();
  
    console.log(
      "Multisig Treasury:",
      MultiSigTreasury.address
    );
  
    console.log(
      "Access Control:",
      AccessControl.address
    );
  };
  
  (async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.error(error);
      process.exit(1);
    }
  })();
  