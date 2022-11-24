// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Administrator {
  address public addr;
  constructor() {
    addr = msg.sender;
  }
}