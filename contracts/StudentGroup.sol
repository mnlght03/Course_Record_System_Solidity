// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract StudentGroup {
  uint public id;
  uint public totalStudents;
  address[] public students;
  mapping (address => uint) public studentIdx;
  // @dev courseId => teacher address
  mapping (uint => address) public courseTeacher;
  bool public deleted;

  constructor(uint _id) {
    id = _id;
  }

  function addStudent(address student) public {
    require(student != address(0), "Student address is zero");
    students.push(student);
    totalStudents++;
    studentIdx[student] = students.length;
  }

  function deleteStudent(address student) public {
    require(student != address(0), "Student address is zero");
    delete students[studentIdx[student]];
    delete studentIdx[student];
    totalStudents--;
  }

  function exists() public view returns (bool) {
    return !deleted;
  }

  function deleteSelf() public {
    delete id;
    delete totalStudents;
    delete students;
    deleted = true;
  }

  function getStudentIdx(address student) internal view returns (uint) {
    require(student != address(0), "Student address is zero");
    return studentIdx[student];
  }

  function getCourseTeacherId(uint courseId) public view returns (address) {
    return courseTeacher[courseId];
  }

  function setCourseTeacher(uint courseId, address teacher) public {
    courseTeacher[courseId] = teacher;
  }

  function deleteCourseTeacher(uint courseId) public {
    delete courseTeacher[courseId];
  }
}