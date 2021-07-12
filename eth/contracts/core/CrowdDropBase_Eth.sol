// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "../roles/Roles.sol";
import "../roles/ExecutivesAccessControl.sol";
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
        
        // the IRL organization that controls their own airdrops.
        // Each group can only be running 1 event at a time.
        uint256 groupId;

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
        
        // Eligible recipients can register for an ongoing event in the state "registration open".
        Roles.Role registeredRecipients;
        
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


    /*** CONSTANTS ***/

    /// @dev A lookup table indicating the cooldown duration after any successful
    ///  breeding action, called "pregnancy time" for matrons and "siring cooldown"
    ///  for sires. Designed such that the cooldown roughly doubles each time a cat
    ///  is bred, encouraging owners not to just keep breeding the same cat over
    ///  and over again. Caps out at one week (a cat can breed an unbounded number
    ///  of times, and the maximum cooldown is always seven days).
    // uint32[14] public cooldowns = [
    //     uint32(1 minutes),
    //     uint32(2 minutes),
    //     uint32(5 minutes),
    //     uint32(10 minutes),
    //     uint32(30 minutes),
    //     uint32(1 hours),
    //     uint32(2 hours),
    //     uint32(4 hours),
    //     uint32(8 hours),
    //     uint32(16 hours),
    //     uint32(1 days),
    //     uint32(2 days),
    //     uint32(4 days),
    //     uint32(7 days)
    // ];

    // // An approximation of currently how many seconds are in between blocks.
    // uint256 public secondsPerBlock = 15;

    // /*** STORAGE ***/

    // /// @dev An array containing the Kitty struct for all Kitties in existence. The ID
    // ///  of each cat is actually an index into this array. Note that ID 0 is a negacat,
    // ///  the unKitty, the mythical beast that is the parent of all gen0 cats. A bizarre
    // ///  creature that is both matron and sire... to itself! Has an invalid genetic code.
    // ///  In other words, cat ID 0 is invalid... ;-)
    // // Kitty[] kitties;

    // /// @dev A mapping from cat IDs to the address that owns them. All cats have
    // ///  some valid owner address, even gen0 cats are created with a non-zero owner.
    // mapping(uint256 => address) public kittyIndexToOwner;

    // // @dev A mapping from owner address to count of tokens that address owns.
    // //  Used internally inside balanceOf() to resolve ownership count.
    // mapping(address => uint256) ownershipTokenCount;

    // /// @dev A mapping from KittyIDs to an address that has been approved to call
    // ///  transferFrom(). Each Kitty can only have one approved address for transfer
    // ///  at any time. A zero value means no approval is outstanding.
    // mapping(uint256 => address) public kittyIndexToApproved;

    // /// @dev A mapping from KittyIDs to an address that has been approved to use
    // ///  this Kitty for siring via breedWith(). Each Kitty can only have one approved
    // ///  address for siring at any time. A zero value means no approval is outstanding.
    // mapping(uint256 => address) public sireAllowedToAddress;

    // /// @dev The address of the ClockAuction contract that handles sales of Kitties. This
    // ///  same contract handles both peer-to-peer sales as well as the gen0 sales which are
    // ///  initiated every 15 minutes.
    // // SaleClockAuction public saleAuction;

    // /// @dev The address of a custom ClockAuction subclassed contract that handles siring
    // ///  auctions. Needs to be separate from saleAuction because the actions taken on success
    // ///  after a sales and siring auction are quite different.
    // SiringClockAuction public siringAuction;

    // /// @dev Assigns ownership of a specific Kitty to an address.
    // function _transfer(
    //     address _from,
    //     address _to,
    //     uint256 _tokenId
    // ) internal {
    //     // Since the number of kittens is capped to 2^32 we can't overflow this
    //     ownershipTokenCount[_to]++;
    //     // transfer ownership
    //     kittyIndexToOwner[_tokenId] = _to;
    //     // When creating new kittens _from is 0x0, but we can't account that address.
    //     if (_from != address(0)) {
    //         ownershipTokenCount[_from]--;
    //         // once the kitten is transferred also clear sire allowances
    //         delete sireAllowedToAddress[_tokenId];
    //         // clear any previously approved ownership exchange
    //         delete kittyIndexToApproved[_tokenId];
    //     }
    //     // Emit the transfer event.
    //     Transfer(_from, _to, _tokenId);
    // }

    // /// @dev An internal method that creates a new kitty and stores it. This
    // ///  method doesn't do any checking and should only be called when the
    // ///  input data is known to be valid. Will generate both a Birth event
    // ///  and a Transfer event.
    // /// @param _matronId The kitty ID of the matron of this cat (zero for gen0)
    // /// @param _sireId The kitty ID of the sire of this cat (zero for gen0)
    // /// @param _generation The generation number of this cat, must be computed by caller.
    // /// @param _genes The kitty's genetic code.
    // /// @param _owner The inital owner of this cat, must be non-zero (except for the unKitty, ID 0)
    // function _createKitty(
    //     uint256 _matronId,
    //     uint256 _sireId,
    //     uint256 _generation,
    //     uint256 _genes,
    //     address _owner
    // ) internal returns (uint256) {
    //     // These requires are not strictly necessary, our calling code should make
    //     // sure that these conditions are never broken. However! _createKitty() is already
    //     // an expensive call (for storage), and it doesn't hurt to be especially careful
    //     // to ensure our data structures are always valid.
    //     require(_matronId == uint256(uint32(_matronId)));
    //     require(_sireId == uint256(uint32(_sireId)));
    //     require(_generation == uint256(uint16(_generation)));

    //     // New kitty starts with the same cooldown as parent gen/2
    //     uint16 cooldownIndex = uint16(_generation / 2);
    //     if (cooldownIndex > 13) {
    //         cooldownIndex = 13;
    //     }

    //     Kitty memory _kitty = Kitty({
    //         genes: _genes,
    //         birthTime: uint64(now),
    //         cooldownEndBlock: 0,
    //         matronId: uint32(_matronId),
    //         sireId: uint32(_sireId),
    //         siringWithId: 0,
    //         cooldownIndex: cooldownIndex,
    //         generation: uint16(_generation)
    //     });
    //     uint256 newKittenId = kitties.push(_kitty) - 1;

    //     // It's probably never going to happen, 4 billion cats is A LOT, but
    //     // let's just be 100% sure we never let this happen.
    //     require(newKittenId == uint256(uint32(newKittenId)));

    //     // emit the birth event
    //     Birth(
    //         _owner,
    //         newKittenId,
    //         uint256(_kitty.matronId),
    //         uint256(_kitty.sireId),
    //         _kitty.genes
    //     );

    //     // This will assign ownership, and also emit the Transfer event as
    //     // per ERC721 draft
    //     _transfer(0, _owner, newKittenId);

    //     return newKittenId;
    // }

    // // Any C-level can fix how many seconds per blocks are currently observed.
    // function setSecondsPerBlock(uint256 secs) external onlyCLevel {
    //     require(secs < cooldowns[0]);
    //     secondsPerBlock = secs;
    // }
}