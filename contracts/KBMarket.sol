// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
// import 'hardhat/console';

contract KBMarket is ReentrancyGuard {
    using Counters for Counters.Counter;

    /**
        - Number of items minting
        - Number of transactions
        - Tokens that have not been sold
        - Keep track of tokens total Number = tokenId
     */

     Counters.Counter private _tokenIds;
     Counters.Counter private _tokensSold;

    //  Determine who is the owner of the contract
    // Charge a lsiting fee so the owner makes a commision
    address payable owner;
    // Deploying to mstic, use Ethereum API with a caveat
    // In matic 0.045matic is in the cents
    uint256 listingPrice = 0.045 ether;

    constructor(){
        owner = payable(msg.sender);
    }

    struct MarketToken {
        uint itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    enum NFTType {
        CLEB, BISOYE
    }

    // tokenId return which marketToken - fetch which one it is
    mapping(uint256 => MarketToken) private idToMarketToken;

    // Listen to Events from front end applications
    event MarketTokenMinted(
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    // get the listing price
    function getListingPrice() public view returns (uint256){
        return listingPrice;
    }

    // two functions to interact with contract
    // 1. create a market item to put it up for sale
    // 2. create a market sale for buying and selling between parties
    function mintMarketItem(
        address nftContract,
        uint tokenId,
        uint price
    )public payable nonReentrant{
        require(price > 0, 'Price must be at least one wei');
        require(msg.value == listingPrice, 'Price must be equal to listing price');

        _tokenIds.increment();
        uint itemId = _tokenIds.current();

        // putting it up for sale - bool - no owner
        idToMarketToken[itemId] = MarketToken(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender),
            payable(address(0)),
            price,
            false
        );

        // NFT transaction
        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

        emit MarketTokenMinted(
            itemId,
            nftContract,
            tokenId,
            msg.sender,
            address(0),
            price,
            false
        );

    }

    // function to conduct transactions and market sales
    function createMarketSale(
        address nftContract,
        uint itemId
    ) public payable nonReentrant{
        uint price = idToMarketToken[itemId].price;
        uint tokenId = idToMarketToken[itemId].tokenId;
        require(msg.value == price, 'Please submit the asking price in order to continue');

        // transfer the amount to the seller
        idToMarketToken[itemId].seller.transfer(msg.value);
        // trnasfer the token from the contract address to the buyer
        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);
        idToMarketToken[itemId].owner = payable(msg.sender);
        idToMarketToken[itemId].sold = true;

        _tokensSold.increment();

        payable(owner).transfer(listingPrice)

    }

    // function to fetchMarketItems - minting,buying and selling
    // return the number of unsold items
    function fetchMarketTokens() public view returns(MarketToken[] memory){
        uint itemCount = _tokenIds.current();
        uint unsoldItemCount = _tokenIds.current - _tokensSold.current();
        uint currentIndex = 0;

        // looping over the number of items createdd (if number has not been sold populate the array)
        MarketToken[] memory items = new MarketToken[](unsoldItemCount);
        for(uint i = 0; i < itemCount; i++){
            if(idToMarketToken[i + 1].owner == address(0)){
                uint currentId = i + 1;
                MarketToken storage currentItem = idToMarketToken[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    // return NFTs use has purchased
    function fetchMyNFTs() public view returns (MarketToken[] memory){
        uint titalItemCount = _tokenIds.current()
    }

}