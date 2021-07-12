// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Roles.sol";

contract RecipientsManager {
  
  event RecipientAdded(address indexed account);
  event RecipientRemoved(address indexed account);

  constructor() public {
  }

}
