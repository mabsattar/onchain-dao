// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

// Replace this line with the Interfaces

contract CryptoDevsDAO is Ownable {
    // We will write contract code here
}

//interface for the FakeNFTMarketplace

interface IFakeNFTMarketplace {

    function getPrice() external view returns (uint256);

    function available(uint256 _tokenId) external view returns (bool);

    function purchase(uint256 _tokenId) external payable;
}

// minimal interface for CruptoDevsNFT containing only two functions
// that we are interested
interface ICryptoDevsNFT {

    function balanceOf(address owner) external view returns(uint256);

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns(uint256);
}

// creating a struct named Proposal containing all relevant information
struct Proposal {

    uint256 nftTokenId;

    uint256 deadline;
    
    uint256 yayVotes;

    uint256 nayVotes;

    bool executed;

    mapping(uint256 => bool) voters;

}

