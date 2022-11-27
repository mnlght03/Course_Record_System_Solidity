// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "./User.sol";

contract Administrator is User {
  constructor(address _addr, uint _id) User (_addr, _id) {}
}
