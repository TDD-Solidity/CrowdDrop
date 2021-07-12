// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./___AdminsManager.sol";
import "./Roles.sol";

abstract contract RecipientsManager is AdminsManager {
    using Roles for Roles.Role;

    event EligibleRecipientAdded(address indexed account, uint256 groupId);
    event EligibleRecipientRemoved(address indexed account, uint256 groupId);

    event RecipientRegistered(address indexed account, uint256 groupId);
    event WinningsClaimed(address indexed account, uint256 groupId);

    constructor() {}

    modifier onlyEligibleRecipients(uint256 groupId) {
        require(isEligibleRecipient(msg.sender, groupId));
        _;
    }

    function isEligibleRecipient(address account, uint256 groupId)
        public
        view
        whenNotPaused
        returns (bool)
    {
        return events[groupId].eligibleRecipients.has(account);
    }

    modifier onlyRegisteredRecipients(uint256 groupId) {
        require(isRegisteredRecipient(msg.sender, groupId));
        _;
    }

    function isRegisteredRecipient(address account, uint256 groupId)
        public
        view
        whenNotPaused
        returns (bool)
    {
        return events[groupId].registeredRecipients.has(account);
    }

    function addEligibleRecipient(address account, uint256 groupId)
        public
        whenNotPaused
        onlyAdmins(groupId)
    {
        events[groupId].eligibleRecipients.add(account);
        emit EligibleRecipientAdded(account, groupId);
    }

    function removeEligibleRecipient(address account, uint256 groupId)
        public
        onlyAdmins(groupId)
        whenNotPaused
    {
        events[groupId].eligibleRecipients.remove(account);
        emit EligibleRecipientRemoved(account, groupId);
    }

    function registerForEvent(uint256 groupId)
        public
        onlyEligibleRecipients(groupId)
        whenNotPaused
    {
        events[groupId].registeredRecipients.add(msg.sender);
        emit RecipientRegistered(msg.sender, groupId);
    }

    function claimWinnings(uint256 groupId)
        public
        onlyRegisteredRecipients(groupId)
        whenNotPaused
    {
        events[groupId].pot.release();
        emit WinningsClaimed(msg.sender, groupId);
    }
}
