// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract AccessControl {
    address public superadmin;
    address[] public owners;
    mapping(address => bool) isOwner;
    uint256 quroum;

    event Confirmation(address indexed sender, uint256 indexed transactionId);
    event Revocation(address indexed sender, uint256 indexed transactionId);
    event Submission(uint256 indexed transactionId);
    event Execution(uint256 indexed transactionId);
    event ExecutionFailure(uint256 indexed transactionId);
    event Deposit(address indexed sender, uint256 value);
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
