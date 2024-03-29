// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract User {
  address addr;
  uint id;

  constructor(address _addr, uint _id) {
    addr = _addr;
    id = _id;
  }

  function getAddress() public view returns (address) {
    return addr;
  }

  function getId() public view returns (uint) {
    return id;
  }
}

contract EducationUser is User {
  uint[] public courseIds;
  uint public totalCourses;
  mapping (uint => bool) attachedCourses;
  // @dev courseId => courseIdx
  mapping (uint => uint) courseIdx;
  constructor(address _addr, uint _id) User(_addr, _id) {}

  function isAttachedToCourse(uint _courseId) internal view returns (bool) {
    return attachedCourses[_courseId];
  }

  function addCourse(uint _courseId) public {
    courseIds.push(_courseId);
    courseIdx[_courseId] = courseIds.length - 1;
    totalCourses++;
    attachedCourses[_courseId] = true;
  }

  function deleteCourse(uint _courseId) public {
    require(isAttachedToCourse(_courseId), "User is not attached to this course");
    delete courseIds[getCourseIdx(_courseId)];
    delete courseIdx[_courseId];
    attachedCourses[_courseId] = false;
    totalCourses--;
  }

  function getCourseId(uint idx) internal view returns (uint) {
    return courseIds[idx];
  }

  function getCourseIdx(uint _courseId) internal view returns (uint){
    return courseIdx[_courseId];
  }
}