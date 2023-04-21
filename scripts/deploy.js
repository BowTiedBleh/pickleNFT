// scripts/deploy.js

require("@nomiclabs/hardhat-ethers");

    async function main() {
        try {
          // Get the contract to deploy
          const PickleNFT = await ethers.getContractFactory("PickleNFT");
          console.log("Deploying PickleNFT contract...");
          const pickleNFT = await PickleNFT.deploy("PickleNFT", "PNFT");

      
          await pickleNFT.deployed();
          console.log(`PickleNFT contract deployed at address: ${pickleNFT.address}`);
        } catch (error) {
          console.error("Error deploying contract:", error);
          process.exit(1);
        }
      }
      
      main()
        .then(() => process.exit(0))
        .catch((error) => {
          console.error("Fatal error during deployment:", error);
          process.exit(1);
        });
      
