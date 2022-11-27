// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "./Teacher.sol";

contract TeacherList {
  Teacher[] public list;
  uint public totalTeachers;
  mapping (address => uint) teacherId;

  function addTeacher(address newTeacherAddr) public {
    require(newTeacherAddr != address(0));
    uint id = list.length + 1;
    list.push(new Teacher(newTeacherAddr, id));
    totalTeachers++;
  }

  function deleteTeacher(address teacherAddr) public {
    require(teacherAddr != address(0));
    list[getTeacherIdByAddress(teacherAddr)].deleteSelf();
    delete list[getTeacherIdByAddress(teacherAddr)];
    delete teacherId[teacherAddr];
    totalTeachers--;
  }

  function getTeacherById(uint _teacherId) public view returns (Teacher) {
    require(_teacherId > 0 && _teacherId <= list.length);
    return list[_teacherId - 1];
  }

  function getTeacherIdByAddress(address teacher) internal view returns (uint) {
    require(teacher != address(0));
    return teacherId[teacher];
  }

  function getTeacherIdx(address teacher) internal view returns (uint) {
    require(teacher != address(0));
    return teacherId[teacher] - 1;
  }

  function getTeacherByAddress(address teacher) public view returns (Teacher) {
    require(teacher != address(0));
    return getTeacherById(getTeacherIdByAddress(teacher));
  }

  function assignTeacherToCourse(address teacher, uint courseId) public {
    require(teacher != address(0));
    list[getTeacherIdx(teacher)].addCourse(courseId);
  }

  function unassignTeacherFromCourse(address teacher, uint courseId) public {
    require(teacher != address(0));
    list[getTeacherIdx(teacher)].deleteCourse(courseId);
  }

  function assignGroupToCourseTeacher(address teacher, uint groupId, uint courseId) public {
    require(teacher != address(0));
    list[getTeacherIdx(teacher)].addGroupToCourse(groupId, courseId);
  }

  function unassignGroupFromCourseTeacher(address teacher, uint groupId, uint courseId) public {
    require(teacher != address(0));
    list[getTeacherIdx(teacher)].deleteGroupFromCourse(groupId, courseId);
  }

  function getCourseTeacher(uint courseId, uint groupId) public view returns (address) {
    for (uint i = 0; i < list.length; i++)
      if(list[i].teachesCourseToGroup(courseId, groupId))
        return list[i].getAddress();
    return address(0);
  }

  function sendRequest(address student, address teacher, uint courseId) public {
    list[getTeacherIdx(teacher)].pushRequest(student, courseId);
  }

  function deleteRequest(address teacher, address student, uint courseId) public {
    list[getTeacherIdx(teacher)].deleteRequest(student, courseId);
  }
}