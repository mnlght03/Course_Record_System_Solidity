// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "./Admin.sol";

contract AdminList {
  Administrator[] public admins;
  mapping (address => uint) adminsIdMapping;
}