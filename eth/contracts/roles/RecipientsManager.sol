// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "../core/CrowdDropBase.sol";
import "./Roles.sol";

contract RecipientsManager is CrowdDropBase {
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
        return eligibleRecipients[groupId].has(account);
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
        return registeredRecipients[groupId].has(account);
    }

    function registerForEvent(uint256 groupId)
        public
        onlyEligibleRecipients(groupId)
        whenNotPaused
    {
        registeredRecipients[groupId].add(msg.sender);
        emit RecipientRegistered(msg.sender, groupId);
    }

    function claimWinnings(uint256 groupId)
        public
        onlyRegisteredRecipients(groupId)
        whenNotPaused
    {
        currentEvents[groupId].pot.release(payable(msg.sender));
        emit WinningsClaimed(msg.sender, groupId);
    }
}
