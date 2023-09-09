//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract FakeNFTMarketplace {

    // maintin a mapping of Fake TokenID to owner address
    mapping(uint256 => address) public tokents;

    //setting up a purchase price for each fake NFT
    uint256  nftprice = 0.1 ether;

    function purchase(uint256 _tokenId) external payable {
        require(msg.value == nftPrice, "This NFT costs 0.1 ether");
        tokens[_tokenId] = msg.sender;
    }

    function getprice() external view returns (uint256) {
        return nftprice;
    }

    function available(uint256 _tokenId) external view returns (bool) {

        if (tokens[_tokenId] == address(0)) {
            return true;
        } 
        return false;

    }
}