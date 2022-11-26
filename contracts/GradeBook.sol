// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract GradeBook {
  enum Grade { NONE, F, D, C, B, A, APLUS }
  struct Entry {
    Grade grade;
    bool attended;
  }
  // @dev date => courseId => student => Entry
  mapping (uint => mapping (address => mapping (uint => Entry))) entries;

  function getBook(uint course, address student, uint startDate, uint endDate) public returns (Entry[] result) {
    uint idx = 0;
    for (uint i = startDate; i < endDate; i++)
      result[idx++] = entries[i][course][student];
  }

  function setGrade(uint date, uint courseId, uint studentId, Grade _grade) public {
    entries[date][courseId][studentId].grade = _grade;
  }

  function markAttendance(uint date, uint courseId, uint studentId, bool status) public {
    entries[date][courseId][studentId].attended = status;
  }
}