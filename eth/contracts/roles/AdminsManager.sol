// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "../core/CrowdDropBase_Eth.sol";
import "./AdminsManager.sol";
import "./ContributorManager.sol";
import "./Roles.sol";

contract AdminsManager is CrowdDropBase_Eth {
    using Roles for Roles.Role;

    event AdminAdded(address indexed account, uint256 groupId);
    event AdminRemoved(address indexed account, uint256 groupId);

    event EventStarted(address indexed account, uint256 groupId);
    event RegistrationEnded(address indexed account, uint256 groupId);
    event EventEnded(address indexed account, uint256 groupId);

    constructor() {}

    modifier onlyAdmins(uint256 groupId) {
        require(isAdmin(msg.sender, groupId));
        _;
    }

    function isAdmin(address account, uint256 groupId)
        public
        view
        returns (bool)
    {
        return currentEvents[groupId].admins.has(account);
    }

    modifier onlyAdminsOrCOO(uint groupId) {
        require(isAdmin(msg.sender, groupId) || msg.sender == cooAddress);
        _;
    }

    // TODO - allow COO to give "admin-granting power" to other admins
    function addAdmin(address account, uint256 groupId) public onlyCOO {
        _addAdmin(account, groupId);
    }

    function removeAdmin(address account, uint256 groupId) public onlyCOO {
        _removeAdmin(account, groupId);
    }

    function renounceAdmin(uint256 groupId) public onlyAdmins(groupId) {
        _removeAdmin(msg.sender, groupId);
    }

    function _addAdmin(address account, uint256 groupId) internal {
        currentEvents[groupId].admins.add(account);
        emit AdminAdded(account, groupId);
    }

    function _removeAdmin(address account, uint256 groupId) internal {
        currentEvents[groupId].admins.remove(account);
        emit AdminRemoved(account, groupId);
    }

    // function readEventInfo(uint groupId) public onlyAdmins(groupId) returns (CrowdDropEvent) {
    //   return events[groupId];
    // }

    // function readEventContributors(uint groupId) public onlyAdmins(groupId) returns (Roles.Role) {
    //   return events[groupId].contributors;
    // }

    // not paused!

    function createNewGroup() public onlyCOO {
        
        // TODO - set startTime

        uint newGroupId = uint256(block.blockhash(block.number));
        
        CrowdDropEvent memory newGroup = CrowdDropEvent(
            newGroupId,
            EventState.CREATED,
            block.timestamp,
            0,
            0,
            AdminsManager(),
            ContributorManager(),
            RecipientsManager(),
            RecipientsManager(),
            "",
            "",
            "",
            0
        );

        currentEvents[newGroupId] = newGroup;

        emit EventStarted();
    }

    function startEvent(uint groupId) public onlyCOO {
        
        // TODO - set startTime
        
        emit EventStarted();
    }

    function closeEventRegistration(uint groupId) public onlyAdmins(groupId) {
    
        // TODO - set registrationEndTime

        currentEvents[groupId].currentState = EventState.CLAIM_WINNINGS;

        // build a PaymentSplitter, passing arrays of registered recipients and shares 

        emit RegistrationEnded();
    }

    function endEvent(uint groupId) public onlyAdminsOrCOO(groupId) {
    
        // TODO - set endTime

        currentEvents[groupId].currentState = EventState.ENDED;
        
        pastEvents[groupId].push(currentEvents[groupId]);

        emit EventEnded();
    }
}
