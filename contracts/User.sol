// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract User {
  address addr;
  bool deleted;
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

  function exists() public view returns (bool) {
    return !deleted;
  }

  function deleteSelf() virtual public {
    delete addr;
    delete id;
    deleted = true;
  }
}

contract EducationUser is User {
  uint[] public courseIds;
  uint public totalCourses;
  mapping (uint => bool) attachedCourses;
  mapping (uint => uint) courseIdx;
  constructor(address _addr, uint _id) User(_addr, _id) {}

  // TODO: ADD EVENTS FOR ADDING AND DELETING COURSES (here or in main contract ?)

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
    require(isAttachedToCourse(_courseId));
    delete courseIds[getCourseIdx(_courseId)];
    attachedCourses[_courseId] = false;
    totalCourses--;
  }

  function deleteSelf() public virtual override {
    delete addr;
    delete id;
    delete totalCourses;
    for (uint i = 0; i < courseIds.length; i++) {
      delete attachedCourses[getCourseId(i)];
      delete courseIdx[getCourseId(i)];
    }
    delete courseIds;
    deleted = true;
  }

  function getCourseId(uint idx) internal view returns (uint) {
    return courseIds[idx];
  }

  function getCourseIdx(uint _courseId) internal view returns (uint){
    return courseIdx[_courseId];
  }
}