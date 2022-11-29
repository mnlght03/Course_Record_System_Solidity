// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "./User.sol";

contract Teacher is EducationUser {
  // @dev courseId => groupIds[]
  mapping (uint => uint[]) public courseGroups;
  // @dev courseId => groupId => bool
  mapping (uint => mapping (uint => bool)) public teachesToGroup;

  struct Request {
    address student;
    uint courseId;
  }

  Request[] public courseRequests;
  uint public totalRequests;

  // @dev student => courseId => requestId
  mapping (address => mapping (uint => uint)) requestId;

  constructor(address _addr, uint _id) EducationUser(_addr, _id) {}

  function pushRequest(address student, uint courseId) public {
    require(teachesCourse(courseId), "Teacher doesn't teach this course");
    courseRequests.push(Request(student, courseId));
    totalRequests++;
    requestId[student][courseId] = courseRequests.length;
  }

  function deleteRequest(address student, uint courseId) public {
    require(requestId[student][courseId] > 0, "Request doesn't exist");
    uint idx = requestId[student][courseId] - 1;
    delete courseRequests[idx];
    if (--totalRequests == 0)
      delete courseRequests;
  }

  function teachesCourse(uint _courseId) public view returns (bool) {
    return isAttachedToCourse(_courseId);
  }

  function teachesCourseToGroup(uint _courseId, uint _groupId) public view returns (bool) {
    return teachesToGroup[_courseId][_groupId];
  }

  function addGroupToCourse(uint _groupId, uint _courseId) public {
    require(teachesCourse(_courseId), "Teacher doesn't teach this course");
    courseGroups[_courseId].push(_groupId);
    teachesToGroup[_courseId][_groupId] = true;
  }

  function getGroupIds(uint _courseId) public view returns (uint[] memory) {
    require(teachesCourse(_courseId), "Teacher doesn't teach this course");
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
