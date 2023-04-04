// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract AccessControl {
    address public superadmin;
    address[] public owners;
    mapping(address => bool) isOwner;

    event CreatedProposal(uint256 indexed _proposalCount);
    event Approval(uint256 indexed _proposalCount);
    event Voting(address indexed owner, uint256 indexed _proposalCount);
    event Execution(uint256 indexed _proposalCount);
    event ExecutionFailure(address indexed owner);
    event Donate(address indexed sender, uint256 amount);
    event OwnerAddition(address indexed owner);
    event OwnerRemoval(address indexed owner);
    event AdminTransfer(address indexed newAdmin);

    modifier notNull(address _address) {
        require(_address != address(0), "Address should not be Null");
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == superadmin, "Only SuperAdmin can execute");
        _;
    }

    modifier ownerExists(address _owner) {
        require(isOwner[_owner] == true, "Owner already exists");
        _;
    }

    modifier ownerNotExists(address _owner) {
        require(isOwner[_owner] == false, "Owner does not exist");
        _;
    }

    constructor(address[] memory _owners) {
        superadmin = msg.sender;
        require(_owners.length >= 4, "Atleast 4 owners required");
        owners = _owners;
    }

    function addOwner(
        address _owner
    ) public onlyAdmin notNull(_owner) ownerNotExists(_owner) {
        owners.push(_owner);
        isOwner[_owner] == true;

        emit OwnerAddition(_owner);
    }

    function removeOwner(
        address _owner
    ) public onlyAdmin notNull(_owner) ownerNotExists(_owner) {
        for (uint256 i = 0; i < owners.length - 1; i++) {
            if (owners[i] == _owner) {
                owners[i] = owners[owners.length - 1];
                break;
            }
        }
        owners.pop();
    }

    function renounceAdmin(address newAdmin) public onlyAdmin {
        superadmin = newAdmin;

        emit AdminTransfer(newAdmin);
    }
}
