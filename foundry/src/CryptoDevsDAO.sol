// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IFakeNFTMarketPlace {
    function getPrice() external view returns (uint256);

    function available(uint256 _tokenId) external view returns (bool);

    function purchase(uint256 _tokenId) external payable;
}

interface ICryptoDevsNFT {
    function balanceOf(address _owner) external view returns (uint256);

    function tokenOfOwnerByIndex(
        address _owner,
        uint256 _index
    ) external view returns (uint256);
}

contract CryptoDevsDAO is Ownable {
    struct Proposal {
        // nftTokenId - the tokenID of the NFT to purchase from FakeNFTMarketplace if the proposal passes
        uint256 nftTokenId;
        // deadline - the UNIX timestamp until which this proposal is active. Proposal can be executed after the deadline has been exceeded.
        uint256 deadline;
        // yayVotes - number of yay votes for this proposal
        uint256 yayVotes;
        // nayVotes - number of nay votes for this proposal
        uint256 nayVotes;
        // executed - whether or not this proposal has been executed yet. Cannot be executed before the deadline has been exceeded.
        bool executed;
        // voters - a mapping of CryptoDevsNFT tokenIDs to booleans indicating whether that NFT has already been used to cast a vote or not
        mapping(uint256 => bool) voters;
    }

    mapping(uint256 => Proposal) public proposals;

    uint256 public numProposals;

    IFakeNFTMarketPlace nftMarketplace;
    ICryptoDevsNFT cryptoDevsNFT;

    Constructor(address _nftMarketplace, address _cryptoDevsNFT)
    Ownable(msg.sender) payable {
        nftMarketplace = IFakeMarketplace(_nftMarketplace);
        cryptoDevsNFT =  ICryptoDevsNFT(_cryptoDevsNFT);

    }

    modifier nftHolderOnly() {
        require(cryptoDevsNFT.balanceOf(msg.sender) >0, "NOT_A_DAO_MEMBER");
        _;
    }
}
