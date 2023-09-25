// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BitLogixNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    string private _baseTokenURI;
    
    mapping(uint256 => string) private _tokenURIs;
    
    constructor() ERC721("BitLogixNFT", "BTT") {}

    function setBaseURI(string memory baseURI) external {
        _baseTokenURI = baseURI;
    }
    // Generates token as a unique identity and it has be minted 
    function mintNFT(address to, string memory tokenURI) external returns (uint256) {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        
        _safeMint(to, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        
        return newTokenId;
    }
    // Only owner like receipent || enterprie can send the nfts 
    function transferNFT(address from, address to, uint256 tokenId) external {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Only NFT owner can transfer");
        safeTransferFrom(from, to, tokenId);
    }

    // here for storing metadata of images ipfs uri is needed to at baseURI
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return string(abi.encodePacked(_baseTokenURI, _tokenURIs[tokenId]));
    }
    // checks the existence of token 
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }
}
