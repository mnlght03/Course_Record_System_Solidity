// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Administrator {
  address public addr;
  uint public adminId;

  constructor(address _addr, uint _id) {
    addr = _addr;
    adminId = _id;
  }

  function getAddress() public view returns (address) {
    return addr;
  }

  function getId() public view returns (uint) {
    return adminId;
  }
}