// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./____RecipientsManager.sol";
import "./Roles.sol";

contract ContributorManager is RecipientsManager {
    using Roles for Roles.Role;

    event ContributorAdded(address indexed account, uint256 groupId);
    event ContributorRemoved(address indexed account, uint256 groupId);

    event ContributionMade(
        address indexed account,
        uint256 groupId,
        uint256 amount
    );

    constructor() {}

    modifier onlyContributor(uint256 groupId) {
        require(isContributor(msg.sender, groupId));
        _;
    }

    function isContributor(address account, uint256 groupId)
        public
        view
        whenNotPaused
        returns (bool)
    {
        return currentEvents[groupId].contributors.has(account);
    }

    function addContributor(address account, uint256 groupId)
        public
        onlyCOO
        whenNotPaused
    {
        _addContributor(account, groupId);
    }

    function removeContributor(address account, uint256 groupId)
        public
        onlyCOO
        whenNotPaused
    {
        _removeContributor(account, groupId);
    }

    function renounceContributor(uint256 groupId)
        public
        onlyContributor(groupId)
        whenNotPaused
    {
        _removeContributor(msg.sender, groupId);
    }

    function _addContributor(address account, uint256 groupId) internal {
        currentEvents[groupId].admins.add(account);
        emit ContributorAdded(account, groupId);
    }

    function _removeContributor(address account, uint256 groupId) internal {
        currentEvents[groupId].admins.remove(account);
        emit ContributorRemoved(account, groupId);
    }

    function contributeToPot(uint256 groupId)
        public
        payable
        onlyContributor(groupId)
        whenNotPaused
    {
        emit ContributionMade(msg.sender, groupId, msg.value);
    }
}
