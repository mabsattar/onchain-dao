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

 //creating a mapping of ID to Proposal
 mapping(uint256 => Proposal) public proposals;

 // number of proposals that have been craeted
 uint256 public numProposals;

 IFakeNFTMarketplace nftMarketplace;
 ICryptoDevsNFT cryptoDevsNFT;

 // creating a payable constructor which initializzes the contract
 //instances for FakeNFTMarketplace and CryptoDevsNFT
 // the payable allows this constructor to accept an ETH deposit when it is being deployed
constructor(address _nftMarketplace, address _cryptoDevsNFT) payable {
    nftMarketpace = IFakeNFTMarketplace(_nftMarketplace);
    cryptoDevsNFT = ICryptoDevsNFT(_cryptoDevsNFT);
}

//creating a modifier which only allows a function to be called by someonone
//who owns atleast 1 CryptoDevsNFT

modifier nftHolderOnly() {
    require(cryptoDevsNFT.balanceOf(msg.sender) > 0, "NOT_A_DAO_MEMBER");
    _;
}
  
function createProposal(uint256 _nftTokenId) 
    external
    nftHolderOnly
    returns (uint256)
{
    required(nftMarketplace.available(_nftTokenId), "NFT_NOT_FOR_SALE");
    Proposal storage proposal = proposals[numProposals];
    proposal.nftTokenId = _nftTokenId;

    proposal.deadline = block.timestamp + 5 minutes;

    numProposals++;

    return numProposals -1;
}

//creating a modifier which only allows a function to be
//called if the given proposal's deadline has not been exceeded yet

modifier activeProposalOnly(uint256 proposalIndex) {
    require(
        proposals[proposalIndex].deadline > block.timestamp,
        "DEADLINE_EXCEEDED"
    );
    _;
}

enum vote {
    YAY, // YAY = 0
    NAY // NAY = 1
}

// voteOnProposal allows a CryptoDevsNFT holder to cast their vote on an active proposal
function voteOnProposal(Uint256 proposalIndex, Vote vote)
    external
    nftHolderOnly
    activeProposalOnly(proposalIndex)

{
    Proposal storage proposal = proposals[proposalIndex]

    uint256 voterNFTBalance = cryptoDevsNFT.balanceOf(msg.sender)
    uint256 numVotes = 0;

    for (uint256 i = 0; i < voterNFTBalance; i++) {
        uint256 tokenId = cryptoDevsNFT.tokenOfOwnerByIndexx(msg.sender, i);
        numVotes++;
        proposal.voters[tokenId] = true;
    }
}
require(numVotes > 0, "ALREADY_VOTED");

if (vote == Vote.YAY) {
    proposal.yayVotes += numVotes;
    
} else {
    proposal.nayVotes += numVotes;
}

modifier inactiveProposalOnly(uint256 proposalIndex) {
    require(
        proposals[proposalIndex].deadline <= block.timestamp,
        "DEADLINE_NOT_EXCEEDED"
    );
    require(
        proposals[proposalIndex].executed == false,
        "PROPOSAL_ALREADY_EXECUTED"
    );
    _;
}
