// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "./AccessControl.sol";

contract Multisig is AccessControl {
    struct Proposal {
        address recipient;
        uint256 value;
        string proposal;
        bool approved;
    }
    uint public proposalCount;
    mapping(address => bool) public hasVoted;
    mapping(uint256 => mapping(address => bool)) public confirmations;
    mapping(uint => Proposal) proposals;

    Proposal[] totalProposals;
    Proposal[] validProposals;

    modifier onlyOwner(address _owners) {
        require(isOwner[_owners] == true, "Only owner can call this function");
        _;
    }

    // modifier isApproved(uint proposalId, address recipient) {
    //     require(
    //         confirmations[proposalId][recipient] == true,
    //         "Proposal already approved"
    //     );
    //     _;
    // }

    modifier isVoted(uint proposalId, address _owners) {
        require(hasVoted[_owners] == false, "Already Voted");
        _;
    }

    constructor(address[] memory _owners) AccessControl(_owners) {}

    function createProposal(
        address _recipent,
        uint _value,
        string memory _proposal
    ) public returns (uint256 proposalId) {
        proposalId = proposalCount;
        proposals[proposalId] = Proposal({
            recipient: _recipent,
            value: _value,
            proposal: _proposal,
            approved: false
        });
        totalProposals.push(proposals[proposalId]);
        proposalCount += 1;
        emit Submission(proposalId);
    }

    function approval(uint proposalId) public onlyAdmin {
        require(
            validProposals[proposalId].approved == false,
            "Already approved"
        );
        validProposals.push(proposals[proposalId]);
        validProposals[proposalId].approved = true;
        // confirmations[proposalId][recipient] = true;
    }

    function voting(
        uint proposalId,
        address _owners
    ) public onlyOwner(msg.sender) isVoted(proposalId, msg.sender) {
        hasVoted[_owners] = true;
    }

    function execute() public {}
}
