// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.0 <0.9.0;

import "./Student.sol";

contract StudentList {
  Student[] public list;
  uint public totalStudents;
  mapping (address => uint) studentId;

  function addStudent(address student, uint group) public {
    require(student != address(0));
    uint id = list.length + 1;
    list.push(new Student(student, id, group));
    studentId[student] = id;
    totalStudents++;
  }

  function deleteStudent(address student) public {
    require(student != address(0));
    list[getStudentIdx(student)].deleteSelf();
    delete list[getStudentIdx(student)];
    delete studentId[student];
    totalStudents--;
  }

  function getStudentIdx(address student) internal view returns (uint) {
    require(student != address(0));
    return studentId[student] - 1;
  }

  function getStudentByAddress(address student) internal view returns (Student) {
    require(student != address(0));
    return list[getStudentIdx(student)];
  }

  function getStudentGroupId(address student) public view returns (uint) {
    require(student != address(0));
    return getStudentByAddress(student).groupId();
  }

  function changeStudentGroup(address student, uint newGroup) public {
    require(student != address(0));
    list[getStudentIdx(student)].setGroupId(newGroup);
  }

  function addStudentToCourse(address student, uint courseId) public {
    require(student != address(0));
    list[getStudentIdx(student)].addCourse(courseId);
  }

  function deleteStudentFromCourse(address student, uint courseId) public {
    require(student != address(0));
    list[getStudentIdx(student)].deleteCourse(courseId);
  }
}