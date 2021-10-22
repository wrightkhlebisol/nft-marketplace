// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/utils/Counters.sol';

contract NFT is ERC721URIStorage{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds; // Keep track of tokenIds

    address contractAddress; // address of marketplace for NFTs to interact

    /**
    * OBJ: give the NFT market the ability to transact with tokens or change ownership
    * setApprovalForAll allows us to do that with contract address
     */

    constructor(address marketplaceAddress) ERC721('KryptoBirds', 'KBIRDS'){
        contractAddress = marketplaceAddress;
    }

    function mintToken(string memory tokenURI) public returns (uint){
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        // set token URI: id and url
        _setTokenURI(newItemId, tokenURI);
        // give the marketplace the approval to transact between users
        setApprovalForAll(contractAddress, true);
        // return item id for transac
        return newItemId;
    }

}