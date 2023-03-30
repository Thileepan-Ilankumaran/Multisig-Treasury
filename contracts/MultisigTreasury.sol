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

    constructor(address[] memory _owners) AccessControl(_owners) {}

    function donate() public payable {
        if (msg.value > 0) {
            emit Donate(msg.sender, msg.value);
        }
    }

    fallback() external payable {
        if (msg.value > 0) {
            emit Donate(msg.sender, msg.value);
        }
    }

    receive() external payable {
        emit Donate(msg.sender, msg.value);
    }

    function createProposal(
        address _recipent,
        uint _value,
        string memory _proposal
    ) public notNull(_recipent) returns (uint256 proposalId) {
        proposalId = proposalCount;
        proposals[proposalId] = Proposal({
            recipient: _recipent,
            value: _value,
            proposal: _proposal,
            approved: false
        });
        totalProposals.push(proposals[proposalId]);
        proposalCount += 1;
        emit CreatedProposal(proposalId);
    }

    function approval(uint proposalId) public isApproved(proposalId) onlyAdmin {
        proposalId = proposalCount;
        totalProposals[proposalId].approved = true;
        emit Approval(proposalId);
    }

    function voting(
        uint proposalId,
        address owner
    )
        public
        isVoted(proposalId, msg.sender)
        notNull(owner)
        onlyOwner(msg.sender)
    {
        require(
            totalProposals[proposalId].approved == true,
            "Only approved proposals can be voted"
        );
        hasVoted[proposalId][owner] = true;
        votes[proposalId]++;
        votesCount++;
        emit Voting(msg.sender, proposalId);
    }

    function execute() public onlyAdmin onlyOwner(msg.sender) {
        uint winner = votes[0];
        uint winnerProposalId = 0;
        //all owners should vote
        for (uint i = 0; i < owners.length; i++) {
            if (hasVoted[winnerProposalId][owners[i]] == false) {
                emit ExecutionFailure(owners[i]);
                return;
            }
        }
        //winning proposal
        for (uint i = 0; i < proposalCount; i++) {
            if (votes[i] > winner) {
                winner = votes[i];
                winnerProposalId = i;
            }
        }

        //51%
        uint num = votesCount * 51;
        uint quorum = num / 100;
        require(winner >= quorum, "Atleast 51% votes required to execute");

        //withdraw
        Proposal storage winningProposal = totalProposals[winnerProposalId];
        require(winningProposal.approved == true, "Not approved by SuperAdmin");
        payable(winningProposal.recipient).transfer(address(this).balance);
        emit Execution(winnerProposalId);
    }
}
