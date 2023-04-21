const { expect } = require("chai");
const { assert } = require("chai");
const { ethers } = require("hardhat");
const Web3 = require("web3");

// Set up a Web3 instance to interact with the local blockchain
const web3 = new Web3("http://localhost:8545");

describe("PickleNFT contract", function () {
  let contract;
  let owner;
  let account;

  beforeEach(async () => {
    // Get a list of all available accounts
    const accounts = await web3.eth.getAccounts();

    // Set the contract owner to the first account in the list
    owner = accounts[0];
    
    // Set the testing account to the second account in the list
    account = accounts[1];

    const PickleNFT = await ethers.getContractFactory("PickleNFT");
    contract = await PickleNFT.deploy("PickleNFT", "PNFT");
    await contract.deployed();
    
    // Get the deployer signer
    deployer = await ethers.getSigner(accounts[0]);
  });

  it("should set the contract name and symbol", async function () {
    expect(await contract.name()).to.equal("PickleNFT");
    expect(await contract.symbol()).to.equal("PNFT");
  });
// Test the constructor properly set roles
  it("should set the DEFAULT_ADMIN_ROLE and MINTER_ROLE to the contract deployer", async function () {
    const DEFAULT_ADMIN_ROLE = '0x0000000000000000000000000000000000000000000000000000000000000000';
    const MINTER_ROLE = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("MINTER_ROLE"));
    expect(await contract.hasRole(DEFAULT_ADMIN_ROLE, deployer.address)).to.equal(true);
    expect(await contract.hasRole(MINTER_ROLE, deployer.address)).to.equal(true);
  });

// Test the mint function
it("should mint a new NFT", async function () {
    // Set up testing variables
    const tokenId = 1;
    const tokenURI = "https://example.com/token/1";

    // Call the mint function with the testing variables
    await contract.mint(account, tokenId, tokenURI);

    // Verify that the NFT was minted with the correct URI
    const uri = await contract.tokenURI(tokenId);
    assert.equal(uri, tokenURI, "Incorrect URI for minted NFT");
  });


// Test the burn function
    it("should burn an existing NFT", async function () {
    // Set up testing variables
    const tokenId = 1;
  
    // Mint a new NFT to test burning
    await contract.mint(account, tokenId, "https://example.com/token/1");
  
    // Call the burn function with the testing variable
    await contract.burn(tokenId);
  
    // Verify that the NFT was burned
    const exists = await contract.exists(tokenId);
    assert.isFalse(exists, "NFT was not burned");
  });
  
});


