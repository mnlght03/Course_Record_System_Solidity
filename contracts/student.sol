// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "./User.sol";

contract Student is EducationUser {
  uint public groupId;

  constructor(address _addr, uint _id, uint _groupId) EducationUser(_addr, _id) {
    groupId = _groupId;
  }

  function studiesCourse(uint _courseId) public view returns (bool) {
    return isAttachedToCourse(_courseId);
  }

  function getGroupId() public view returns (uint) {
    return groupId;
  }

  function setGroupId(uint _groupId) public {
    groupId = _groupId;
  }

  // function requestToJoinCourse(uint _courseId) public {

  // }
}