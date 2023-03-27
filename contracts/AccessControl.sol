// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract AccessControl {
    address public superadmin;
    address[] public owners = [superadmin];
    mapping(address => bool) isOwner;

    event CreatedProposal(uint256 indexed proposalId);
    event Approval(uint256 indexed proposalId);
    event Voting(address indexed owner, uint256 indexed proposalId);
    event Execution(uint256 indexed proposalId);
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

    modifier ownerExists(address owner) {
        require(isOwner[owner] == true, "Owner already exists");
        _;
    }

    modifier ownerNotExists(address owner) {
        require(isOwner[owner] == false, "Owner does not exist");
        _;
    }

    constructor(address[] memory _owners) {
        superadmin = msg.sender;
        require(owners.length >= 4, "Atleast 4 owners required");
        _owners = owners;
    }

    function addOwner(
        address owner
    ) public onlyAdmin notNull(owner) ownerNotExists(owner) {
        owners.push(owner);
        isOwner[owner] == true;

        emit OwnerAddition(owner);
    }

    function removeOwner(
        address owner
    ) public onlyAdmin notNull(owner) ownerNotExists(owner) {
        for (uint256 i = 0; i < owners.length - 1; i++) {
            if (owners[i] == owner) {
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
