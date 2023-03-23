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
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    mapping(uint256 => mapping(address => bool)) public confirmations;
    mapping(uint => Proposal) proposals;

    Proposal[] validProposals;

    modifier onlyOwner(address owner) {
        require(isOwner[owner] == true, "Only owner can call this function");
        _;
    }

    // modifier isApproved(uint proposalId, address recipient) {
    //     require(
    //         confirmations[proposalId][recipient] == true,
    //         "Proposal already approved"
    //     );
    //     _;
    // }

    modifier isVoted(uint proposalId, address owner) {
        require(hasVoted[proposalId][owner] == false, "Already Voted");
        _;
    }

    fallback() external payable {
        if (msg.value > 0) {
            emit Deposit(msg.sender, msg.value);
        }
    }

    receive() external payable {
        if (msg.value > 0) {
            emit Deposit(msg.sender, msg.value);
        }
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

        proposalCount += 1;
        emit Submission(proposalId);
    }

    function approval(uint proposalId, address recipient) public onlyAdmin {
        require(
            confirmations[proposalId][recipient] == false,
            "Already approved"
        );
        confirmations[proposalId][recipient] = true;
        proposals.push;
    }

    function revoke(
        uint proposalId,
        address recipient
    ) public onlyAdmin returns (bool _confirmations) {
        require(
            confirmations[proposalId][recipient] == true,
            "Not approved yet"
        );
        return confirmations[proposalId][recipient] = false;
    }

    function voting(
        uint proposalId,
        address owner
    ) public onlyOwner(msg.sender) isVoted(proposalId, msg.sender) {
        hasVoted[proposalId][owner] = true;
    }
}
