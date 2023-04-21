// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import contracts
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract PickleNFT is ERC721, AccessControl {
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // Define MINTER_ROLE and set it to a hashed string
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    mapping(uint256 => string) private _tokenURIs;
    
    // Events to emit when an NFT is minted and when an NFT is burned
    event NFTMinted(
        address indexed to,
        uint256 indexed tokenId,
        string tokenURI
    );
    event NFTBurned(uint256 indexed tokenId);

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        // Set the DEFAULT_ADMIN_ROLE and MINTER_ROLE to the contract deployer
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
    }

    // Function to set tokenURI 
    function _setTokenURI(
        uint256 tokenId,
        string memory _tokenURI
    ) internal virtual {
        require(_exists(tokenId), "PickleNFT: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    // Mint function that takes recipient address, tokenID, and tokenURI as arguments. Only allows MINTER_ROLE to call this function
    function mint(
        address _to,
        uint256 _tokenId,
        string memory _tokenURI
    )
        public
        onlyRole(MINTER_ROLE)
    {
        // Mint new NFT with the specified ID and send it to the recipient address
        _safeMint(_to, _tokenId);
        // Set the URI for the token
        _setTokenURI(_tokenId, _tokenURI);
        emit NFTMinted(_to, _tokenId, _tokenURI);
    }

    // Define a function called burn that takes tokenID as an argument
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
        return "ipfs://<hash>"; // base URI for the tokens
    }
}
