// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract GradeBook {
  enum Grade { NONE, F, D, C, B, A, APLUS }
  struct Entry {
    Grade grade;
    bool attended;
  }
  // @dev date => courseId => student => Entry
  mapping (uint => mapping (address => mapping (address => Entry))) entries;

  // @dev student => course => total score
  mapping (address => mapping (uint => uint)) public totalScore;

  // @dev student => course => total score
  mapping (address => mapping (uint => uint)) public totalMarks;

  // @dev student => course => total lessons passed since student joined
  mapping (address => mapping (uint => uint)) public totalLessons;

  // @dev student => course => total lessons attended
  mapping (address => mapping (uint => uint)) public totalAttended;

  function getBook(uint course, address student, uint startDate, uint endDate) public returns (Entry[] result) {
    uint idx = 0;
    for (uint i = startDate; i < endDate; i++)
      result[idx++] = entries[i][course][student];
  }

  function setGrade(uint date, uint courseId, address student, Grade _grade) public {
    int difference = uint8(_grade) - entries[date][courseId][student];
    entries[date][courseId][studentId].grade = _grade;
    totalScore[student][courseId] += difference;
    totalMarks[student][courseId]++;
  }

  function markAttendance(uint date, uint courseId, address student, bool status) public {
    entries[date][courseId][student].attended = status;
  }

  function getAverageScore(address student, uint course) public view returns (uint) {
    return totalScore[student][course] / totalMarks[student][course];
  }

  // @dev returns average attendance in percentage
  function getAverageAttendance(address student, uint course) public view returns (uint) {
    return totalAttended[student][course] * 100 / totalLessons[student][course];
  }
}