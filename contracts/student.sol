// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Student {
  address public addr;
  bool public studies;
  uint public studentId;
  uint public groupId;
  uint[] public courseIds;
  uint totalCourses;
  mapping (uint => bool) enrolledTo;

  constructor(address _addr, uint _id, uint _groupId) {
    addr = _addr;
    studies = true;
    studentId = _id;
    groupId = _groupId;
    totalCourses = 0;
  }

  function getAddress() public view returns (address) {
    return addr;
  }

  function getId() public view returns (uint) {
    return studentId;
  }

  function isEnrolledTo(uint _courseId) public view returns (bool) {
    return enrolledTo[_courseId];
  }

  function setGroupId(uint _groupId) public {
    groupId = _groupId;
  }

  function enrollToCourse(uint _courseId) public {
    courseIds.push(_courseId);
    enrolledTo[_courseId] = true;
    totalCourses++;
  }

  function requestToJoinCourse(uint _courseId) public {

  }
}