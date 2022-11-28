// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "./Course.sol";

contract CourseList {
  Course[] public list;
  uint public totalCourses;
  // @dev name => id
  mapping (string => uint) public courseId;

  function getListLength() public view returns (uint) {
    return list.length;
  }

  function getCourseIdx(uint id) internal view returns (uint) {
    require(courseExists(id), "getCourseIdx: Course doesn't exist");
    return id - 1;
  }

  function courseExists(uint id) public view returns (bool) {
    if (id == 0 || id > list.length)
      return false;
    return address(list[id - 1]) != address(0);
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
    courseId[name] = id;
    totalCourses++;
  }

  function deleteCourse(uint id) public {
    require(courseExists(id), "deleteCourse: Course doesn't exist");
    delete courseId[getCourseName(id)];
    delete list[getCourseIdx(id)];
    totalCourses--;
  }

  function courseAvailableForGroup(uint _courseId, uint _groupId) public view returns (bool) {
    return getCourse(_courseId).availableForGroup(_groupId);
  }

  function makeCourseAvailableForGroup(uint _courseId, uint _groupId) public {
    require(courseExists(_courseId), "makeCourseAvailableForGroup: Course doesn't exist");
    list[getCourseIdx(_courseId)].makeAvailableForGroup(_groupId);
  }

  function makeCourseUnavailableForGroup(uint _courseId, uint _groupId) public {
    require(courseExists(_courseId), "makeCourseUnavailableForGroup: Course doesn't exist");
    list[getCourseIdx(_courseId)].makeUnavailableForGroup(_groupId);
  }

  function addTeacher(uint _courseId, address teacher) public {
    require(courseExists(_courseId), "addTeacher: course doesn't exist");
    list[getCourseIdx(_courseId)].addTeacher(teacher);
  }

  function deleteTeacher(uint _courseId, address teacher) public {
    require(courseExists(_courseId), "addTeacher: course doesn't exist");
    list[getCourseIdx(_courseId)].deleteTeacher(teacher);
  }
}