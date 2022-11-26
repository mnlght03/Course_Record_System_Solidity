// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "./User.sol";

contract StudentGroup {
  uint id;
  uint totalStudents;
  uint[] studentIds;
  // @dev id => idx
  mapping (uint => uint) studentIdx;
  // @dev courseId => teacherId
  mapping (uint => uint) courseTeachers;
  bool deleted;

  constructor(uint _id) {
    id = _id;
  }

  function addStudent(uint studentId) public {
    studentIds.push(studentId);
    studentIdx[studentId] = studentIds.length - 1;
    totalStudents++;
  }

  function exists() public view returns (bool) {
    return !deleted;
  }

  function deleteSelf() public {
    delete id;
    delete totalStudents;
    for (uint i = 0; i < studentIds.length; i++)
      delete studentIdx[getStudentId(i)];
    delete studentIds;
    deleted = true;
  }

  function deleteStudent(uint studentId) public {
    delete studentIds[getStudentIdx(studentId)];
    delete studentIdx[studentId];
    totalStudents--;
  }

  function getStudentId(uint idx) internal view returns (uint) {
    return studentIds[idx];
  }

  function getStudentIdx(uint _id) internal view returns (uint) {
    return studentIdx[_id];
  }

  function getCourseTeacherId(uint courseId) public view returns (uint) {
    return courseTeachers[courseId];
  }

  function setCourseTeacher(uint courseId, uint teacherId) public {
    courseTeachers[courseId] = teacherId;
  }

  function deleteCourseTeacher(uint courseId) public {
    delete courseTeachers[courseId];
  }
}