// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "../roles/Roles.sol";
import "../roles/_ExecutivesAccessControl.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";

contract CrowdDropBase_Eth is ExecutivesAccessControl {
    /*** EVENTS ***/

    /// @dev The RegistrationOpen event is fired whenever a new event starts and users can begin restering.
    event RegistrationOpen();

    /// @dev The RegistrationOpen event is fired whenever a new event starts and users can begin restering.
    //    After this event fires users can no longer register, and users who have registered can claim winnings.
    event WinningsClaimingOpen();

    /// @dev The EventClose event is fired whenever an event closes. After this event is fired users can no
    //    longer claim winnings
    event EventClose();

    /// @dev Transfer event as defined in current draft of ERC721. Emitted every some Eth is transferred

    event Transfer(address from, address to); // Assumed Eth

    // TODO - (in later, more than just eth contracts as pass tokenId)
    // event Transfer(address from, address to, uint256 tokenId);

    /*** DATA TYPES ***/

    /// @dev The main Kitty struct. Every cat in CryptoKitties is represented by a copy
    ///  of this structure, so great care was taken to ensure that it fits neatly into
    ///  exactly two 256-bit words. Note that the order of the members in this structure
    ///  is important because of the byte-packing rules used by Ethereum.
    ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html

    // TODO - ^ think harder about all that byte-packing junk... 😅

    enum EventState { CREATED, REGISTRATION, CLAIM_WINNINGS, ENDED }

    struct CrowdDropEvent {
        
        // The IRL organization that controls their own airdrops.
        // Each group can only be running 1 event at a time.
        uint256 groupId;

        // Event goes through a linear flow of states, finite state machine.
        EventState currentState;

        // The timestamp from the block when this event started.
        uint64 startTime;
        // The timestamp from the block when registration for this event ended.
        uint64 registrationEndTime;
        // The timestamp from the block when this event ended.
        uint64 endTime;

        // Keeping track of different types of users and their _roles_
        Roles.Role admins;
        Roles.Role contributors;
        
        // All recipients must be added into the system once initially 
        // by an admin
        Roles.Role eligibleRecipients;
        
        // An array (easier to pass into PaymentSplitter)
        Roles.Role registeredRecipientsArray;
        
        // Eligible recipients can register for an ongoing event in the state "registration open".
        Roles.Role registeredRecipients;
        
        // The number of eligibleRecipients who have registered.
        uint registeredRecipientsCount;
        
        // Data about the sponsor info (address is stored in Roles)
        string sponsorName;
        string sponsorImageUrl;
        string sponsorLinkToUrl;

        // Keeping track of winnings claimings
        PaymentSplitter pot;

    }

    // Events happening now or in the future.
    // Key is the groupId
    mapping(uint => CrowdDropEvent) currentEvents;
    
    // Events that have already happened.
    // Key is the groupId
    mapping(uint => CrowdDropEvent[]) pastEvents;

    // Any C-level can fix how many seconds per blocks are currently observed.
    // function setSecondsPerBlock(uint256 secs) external onlyCLevel {
    //     require(secs < cooldowns[0]);
    //     secondsPerBlock = secs;
    // }
}