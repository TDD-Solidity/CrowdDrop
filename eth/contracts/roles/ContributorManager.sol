// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./AdminsManager.sol";
import "./Roles.sol";

contract ContributorManager is AdminsManager {
    using Roles for Roles.Role;

    event ContributorAdded(address indexed account, uint256 groupId);
    event ContributorRemoved(address indexed account, uint256 groupId);
    
    event ContributionMade(address indexed account, uint256 groupId, uint amount);

    constructor() {}

    modifier onlyContributor(uint256 groupId) {
        require(isContributor(msg.sender, groupId));
        _;
    }

    function isContributor(address account, uint256 groupId)
        public
        view
        returns (bool)
    {
        return currentEvents[groupId].contributors.has(account);
    }

    function addContributor(address account, uint256 groupId) public onlyCOO {
        _addContributor(account, groupId);
    }

    function removeContributor(address account, uint256 groupId)
        public
        onlyCOO
    {
        _removeContributor(account, groupId);
    }

    function renounceContributor(uint256 groupId)
        public
        onlyContributor(groupId)
    {
        _removeContributor(msg.sender, groupId);
    }

    // not paused!

    function _addContributor(address account, uint256 groupId) internal {
        currentEvents[groupId].admins.add(account);
        emit ContributorAdded(account, groupId);
    }

    function _removeContributor(address account, uint256 groupId) internal {
        currentEvents[groupId].admins.remove(account);
        emit ContributorRemoved(account, groupId);
    }

    function contributeToPot(uint groupId) public payable onlyContributor(groupId) {
        emit ContributionMade(msg.sender, groupId, msg.value);
    }

}
