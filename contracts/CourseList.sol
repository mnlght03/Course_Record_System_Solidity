// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "./Course.sol";

contract CourseList {
  Course[] public list;
  uint public totalCourses;
  // @dev name => id
  mapping (string => uint) courseId;

  function getCourseIdx(uint id) internal pure returns (uint) {
    require (id > 0);
    return id - 1;
  }

  function courseExists(uint id) public view returns (bool) {
    if (id == 0)
      return false;
    return list[getCourseIdx(id)].exists();
  }

  function getCourse(uint id) public view returns (Course) {
    return list[getCourseIdx(id)];
  }

  function getCourseId(string calldata name) public view returns (uint) {
    return courseId[name];
  }

  function getCourseName(uint id) public view returns (string memory) {
    return getCourse(id).name();
  }

  function addCourse(string calldata name) public {
    uint id = list.length + 1;
    list.push(new Course(name, id));
    totalCourses++;
  }

  function deleteCourse(uint id) public {
    require (courseExists(id));
    list[getCourseIdx(id)].deleteSelf();
    delete list[getCourseIdx(id)];
    totalCourses--;
  }

  function courseAvailableForGroup(uint _courseId, uint _groupId) public view returns (bool) {
    return getCourse(_courseId).availableForGroup(_groupId);
  }

  function makeCourseAvailableForGroup(uint _courseId, uint _groupId) public {
    list[getCourseIdx(_courseId)].makeAvailableForGroup(_groupId);
  }

  function makeCourseUnavailableForGroup(uint _courseId, uint _groupId) public {
    list[getCourseIdx(_courseId)].makeUnavailableForGroup(_groupId);
  }
}