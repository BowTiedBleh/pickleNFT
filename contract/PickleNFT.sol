// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the ERC721 contract from OpenZeppelin
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// Import the AccessControl contract from OpenZeppelin
import "@openzeppelin/contracts/access/AccessControl.sol";

// Define a contract called PickleNFT that inherits from ERC721 and AccessControl
contract PickleNFT is ERC721, AccessControl {
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // Define a constant variable called MINTER_ROLE and set it to a hashed string
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    mapping(uint256 => string) private _tokenURIs;

    event NFTMinted(
        address indexed to,
        uint256 indexed tokenId,
        string tokenURI
    );
    event NFTBurned(uint256 indexed tokenId);

    // Define a constructor function that takes two string arguments and calls the ERC721 constructor with them
    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        // Set the DEFAULT_ADMIN_ROLE to the contract deployer
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        // Set the MINTER_ROLE to the contract deployer
        _setupRole(MINTER_ROLE, msg.sender);
    }

    function _setTokenURI(
        uint256 tokenId,
        string memory _tokenURI
    ) internal virtual {
        require(_exists(tokenId), "PickleNFT: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    // Define a function called mint that takes an address, a uint256, and a string as arguments
    function mint(
        address _to,
        uint256 _tokenId,
        string memory _tokenURI
    )
        public
        onlyRole(MINTER_ROLE) // Only allow the MINTER_ROLE to call this function
    {
        // Mint a new NFT with the specified ID and send it to the recipient
        _safeMint(_to, _tokenId);
        // Set the URI for the token
        _setTokenURI(_tokenId, _tokenURI);
        emit NFTMinted(_to, _tokenId, _tokenURI);
    }

    // Define a function called burn that takes a uint256 as an argument
    function burn(uint256 _tokenId) public onlyRole(MINTER_ROLE) {
        // Destroy the token with the specified ID
        _burn(_tokenId);
        emit NFTBurned(_tokenId);
    }

    // Override the ERC721 function called tokenURI to return the URI for a specific token ID
    function tokenURI(
        uint256 _tokenId
    ) public view virtual override returns (string memory) {
        // Require that the token with the specified ID exists
        require(_exists(_tokenId), "URI query for nonexistent token");

        // Get the base URI for the token
        string memory baseURI = _baseURI();
        // If the base URI is not empty, concatenate it with the token ID and return the result
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, _tokenId))
                : "";
    }

    // Override the ERC721 function called _baseURI to return the base URI for the tokens
    function _baseURI() internal view virtual override returns (string memory) {
        return "ipfs://<hash>"; // Set the base URI for the tokens
    }
}
