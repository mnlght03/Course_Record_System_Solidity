// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract GradeBook {
  enum Grade { NONE, ONE, F, D, C, B, A, APLUS }
  struct Entry {
    Grade grade;
    bool attended;
  }
  // @dev date => courseId => student => Entry
  mapping (uint => mapping (uint => mapping (address => Entry))) public entries;

  // @dev student => course => total score
  mapping (address => mapping (uint => uint)) public totalScore;

  // @dev student => course => total score
  mapping (address => mapping (uint => uint)) public totalMarks;

  // @dev student => course => total lessons passed since student joined
  mapping (address => mapping (uint => uint)) public totalLessons;

  // @dev student => course => total lessons attended
  mapping (address => mapping (uint => uint)) public totalAttended;

  function getBook(uint course, address student, uint startDate, uint endDate) public view returns (Entry[] memory result) {
    uint idx = 0;
    for (uint i = startDate; i < endDate; i++)
      result[idx++] = entries[i][course][student];
  }

  function max(uint a, uint b) internal pure returns (uint) {
    return a > b ? a : b;
  }

  function min(uint a, uint b) internal pure returns (uint) {
    return a < b ? a : b;
  }

  function setGrade(uint date, uint courseId, address student, uint _grade) public {
    uint diff = max(_grade, uint(entries[date][courseId][student].grade)) - min(_grade, uint(entries[date][courseId][student].grade));
    if (max(_grade, uint(entries[date][courseId][student].grade)) == _grade)
      totalScore[student][courseId] += diff;
    else
      totalScore[student][courseId] -= diff;
    entries[date][courseId][student].grade = Grade(_grade);
    if (diff == _grade)
      totalMarks[student][courseId]++;
  }

  function increaseTotalLessons(address student, uint courseId) public {
    require(student != address(0), "Student address is zero");
    require(courseId > 0, "Course id cannot be zero");
    totalLessons[student][courseId]++;
  }

  function decreaseTotalLessons(address student, uint courseId) public {
    require(student != address(0), "Student address is zero");
    require(courseId > 0, "Course id cannot be zero");
    if (totalLessons[student][courseId] > 0)
      totalLessons[student][courseId]--;
  }

  function markAttendance(uint date, uint courseId, address student, bool status) public {
    entries[date][courseId][student].attended = status;
    totalAttended[student][courseId]++;
  }

  function getAverageScore(address student, uint course) public view returns (uint) {
    return totalScore[student][course] / totalMarks[student][course];
  }

  // @dev returns average attendance in percentage
  function getAverageAttendance(address student, uint course) public view returns (uint) {
    return totalAttended[student][course] * 100 / totalLessons[student][course];
  }
}