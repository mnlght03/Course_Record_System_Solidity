// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.0 <0.9.0;

import "./Student.sol";

contract StudentList {
  Student[] public list;
  uint public totalStudents;
  mapping (address => uint) public studentId;

  function addStudent(address student, uint group) public {
    require(student != address(0), "Student address is zero");
    require(!studentExists(student), "Student already exists");
    uint id = list.length + 1;
    list.push(new Student(student, id, group));
    studentId[student] = id;
    totalStudents++;
  }

  function studentExists(address student) public view returns (bool) {
    if (student == address(0) || studentId[student] == 0)
      return false;
    return true;
  }

  function deleteStudent(address student) public {
    require(studentExists(student), "Student doesn't exist");
    delete list[getStudentIdx(student)];
    delete studentId[student];
    totalStudents--;
  }

  function deleteCourse(uint _courseId) public {
    for (uint i = 0; i < list.length; i++)
      if(list[i].studiesCourse(_courseId))
        list[i].deleteCourse(_courseId);
  }

  function getStudentIdx(address student) public view returns (uint) {
    require(studentExists(student), "Student doesn't exist");
    return studentId[student] - 1;
  }

  function getStudentByAddress(address student) public view returns (Student) {
    require(studentExists(student), "Student doesn't exist");
    return list[getStudentIdx(student)];
  }

  function getStudentGroupId(address student) public view returns (uint) {
    require(studentExists(student), "Student doesn't exist");
    return getStudentByAddress(student).groupId();
  }

  function changeStudentGroup(address student, uint newGroup) public {
    require(studentExists(student), "Student doesn't exist");
    list[getStudentIdx(student)].setGroupId(newGroup);
  }

  function addStudentToCourse(address student, uint courseId) public {
    require(studentExists(student), "Student doesn't exist");
    list[getStudentIdx(student)].addCourse(courseId);
  }

  function deleteStudentFromCourse(address student, uint courseId) public {
    require(studentExists(student), "Student doesn't exist");
    list[getStudentIdx(student)].deleteCourse(courseId);
  }
}