// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "./User.sol";

contract Teacher is EducationUser {
  // @dev courseId => groupIds[]
  mapping (uint => uint[]) public courseGroups;
  // @dev courseId => groupId => bool
  mapping (uint => mapping (uint => bool)) teachesToGroup;

  constructor(address _addr, uint _id) EducationUser(_addr, _id) {}

  function teachesCourse(uint _courseId) public view returns (bool) {
    return isAttachedToCourse(_courseId);
  }

  function teachesCourseToGroup(uint _courseId, uint _groupId) public view returns (bool) {
    return teachesToGroup[_courseId][_groupId];
  }

  function addGroupToCourse(uint _groupId, uint _courseId) public {
    require(teachesCourse(_courseId));
    courseGroups[_courseId].push(_groupId);
    teachesToGroup[_courseId][_groupId] = true;
  }

  function getGroupIds(uint _courseId) public view returns (uint[] memory) {
    require(teachesCourse(_courseId));
    return courseGroups[_courseId];
  }

  function deleteGroupFromCourse(uint _groupId, uint _courseId) public {
    uint[] storage groups = courseGroups[_courseId];
    for (uint i = 0; i < groups.length; i++)
      if (groups[i] == _groupId) {
        delete groups[i];
        break;
      }
    teachesToGroup[_courseId][_groupId] = false;
  }
}