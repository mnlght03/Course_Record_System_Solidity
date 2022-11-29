// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "./Teacher.sol";

contract TeacherList {
  Teacher[] public list;
  uint public totalTeachers;
  mapping (address => uint) public teacherId;

  function teacherExists(address teacher) public view returns (bool) {
    if (teacher == address(0) || teacherId[teacher] == 0)
      return false;
    return true;
  }

  function addTeacher(address newTeacherAddr) public {
    require(!teacherExists(newTeacherAddr), "Teacher already exists");
    uint id = list.length + 1;
    list.push(new Teacher(newTeacherAddr, id));
    teacherId[newTeacherAddr] = id;
    totalTeachers++;
  }

  function deleteTeacher(address teacherAddr) public {
    require(teacherExists(teacherAddr), "Teacher doesn't exist");
    delete list[getTeacherIdx(teacherAddr)];
    delete teacherId[teacherAddr];
    totalTeachers--;
  }

  function getTeacherById(uint _teacherId) public view returns (Teacher) {
    require(_teacherId > 0 && _teacherId <= list.length, "Teacher doesn't exist");
    return list[_teacherId - 1];
  }

  function getTeacherIdByAddress(address teacher) public view returns (uint) {
    require(teacherExists(teacher), "Teacher doesn't exist");
    return teacherId[teacher];
  }

  function getTeacherIdx(address teacher) internal view returns (uint) {
    require(teacherExists(teacher), "Teacher doesn't exist");
    return teacherId[teacher] - 1;
  }

  function getTeacherByAddress(address teacher) public view returns (Teacher) {
    require(teacherExists(teacher), "Teacher doesn't exist");
    return getTeacherById(getTeacherIdByAddress(teacher));
  }

  function assignTeacherToCourse(address teacher, uint courseId) public {
    require(teacherExists(teacher), "Teacher doesn't exist");
    list[getTeacherIdx(teacher)].addCourse(courseId);
  }

  function unassignTeacherFromCourse(address teacher, uint courseId) public {
    require(teacherExists(teacher), "Teacher doesn't exist");
    list[getTeacherIdx(teacher)].deleteCourse(courseId);
  }

  function assignGroupToCourseTeacher(address teacher, uint groupId, uint courseId) public {
    require(teacherExists(teacher), "Teacher doesn't exist");
    list[getTeacherIdx(teacher)].addGroupToCourse(groupId, courseId);
  }

  function unassignGroupFromCourseTeacher(address teacher, uint groupId, uint courseId) public {
    require(teacherExists(teacher), "Teacher doesn't exist");
    list[getTeacherIdx(teacher)].deleteGroupFromCourse(groupId, courseId);
  }

  function getCourseTeacher(uint courseId, uint groupId) public view returns (address) {
    for (uint i = 0; i < list.length; i++)
      if(address(list[i]) != address(0) && list[i].teachesCourseToGroup(courseId, groupId))
        return list[i].getAddress();
    return address(0);
  }

  function sendRequest(address student, address teacher, uint courseId) public {
    require(student != address(0), "Student is zero address");
    require(teacherExists(teacher), "Teacher doesn't exist");
    list[getTeacherIdx(teacher)].pushRequest(student, courseId);
  }

  function deleteRequest(address teacher, address student, uint courseId) public {
    require(student != address(0), "Student is zero address");
    require(teacherExists(teacher), "Teacher doesn't exist");
    list[getTeacherIdx(teacher)].deleteRequest(student, courseId);
  }
}