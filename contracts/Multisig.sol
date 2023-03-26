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
    uint public votesCount;
    mapping(uint256 => mapping(address => bool)) public hasVoted; //
    mapping(uint => Proposal) proposals; //0,1,2,3
    mapping(uint => uint) public votes;

    Proposal[] totalProposals;

    modifier onlyOwner(address owner) {
        require(isOwner[owner] == true, "Only owner can call this function");
        _;
    }

    modifier isApproved(uint proposalId) {
        require(
            totalProposals[proposalId].approved == false,
            "Already approved"
        );
        _;
    }

    modifier isVoted(uint proposalId, address owner) {
        require(hasVoted[proposalId][owner] == false, "Already Voted");
        _;
    }

    function createProposal(
        address _recipent,
        uint _value,
        string memory _proposal
    ) public payable returns (uint256 proposalId) {
        proposalId = proposalCount;
        proposals[proposalId] = Proposal({
            recipient: _recipent,
            value: _value,
            proposal: _proposal,
            approved: false
        });
        totalProposals.push(proposals[proposalId]);
        proposalCount += 1;
    }

    function approval(uint proposalId) public isApproved(proposalId) onlyAdmin {
        proposalId = proposalCount;
        totalProposals[proposalId].approved = true;
    }

    function voting(
        uint proposalId,
        address owners
    ) public isVoted(proposalId, msg.sender) onlyOwner(msg.sender) {
        require(
            totalProposals[proposalId].approved == true,
            "Only approved proposals can be voted"
        );
        hasVoted[proposalId][owners] = true;
        votes[proposalId]++;
        votesCount++;
        execute();
    }

    function execute() public {
        //winning proposal
        uint winner = votes[0];
        for (uint i = 0; i < proposalCount; i++) {
            if (votes[i] > winner) {
                winner = votes[i];
            }
        }
        //51%
        uint num = votesCount * 51;
        uint quorum = num / 100;

        require(winner >= quorum, "Atleast 51% votes required to execute");
        //withdraw
    }
}
