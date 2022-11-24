// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "./student.sol";

contract Teacher {
  address public addr;
  constructor(address _addr) {
    addr = _addr;
  }
  event MarkedAttendance(address teacherAddr, address studentAddr, string courseName, uint256 date, bool attendanceStatus);
  event SetGrade(address teacherAddr, address studentAddr, string courseName, uint256 date, uint256 grade);
  event AssignedToCourse(address teacherAddr, string courseName);
  
  mapping (string => bool) courses;

  function teachesCourse(string calldata courseName) public view returns (bool) {
    return courses[courseName];
  }

  function assignToCourse(string calldata courseName) public {
    courses[courseName] = true;
    emit AssignedToCourse(addr, courseName);
  }
  
  function markAttendance(Student student, string calldata courseName, uint256 date, bool attendanceStatus) public {
    require(this.teachesCourse(courseName));
    require(student.isEnrolled(courseName));
    student.setAttendance(courseName, date, attendanceStatus);
    emit MarkedAttendance(this.addr(), student.addr(), courseName, date, attendanceStatus);
  }
  function setGrade(Student student, string calldata courseName, uint256 date, uint256 grade) public {
    require(this.teachesCourse(courseName));
    require(student.isEnrolled(courseName));
    student.setGrade(courseName, date, grade);
    emit SetGrade(this.addr(), student.addr(), courseName, date, grade);
  }
}