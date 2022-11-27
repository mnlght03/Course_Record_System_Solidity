// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract TimeTable {
  enum DayOfTheWeek { SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY }
  enum NumberOfLesson { NONE, FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH }

  mapping (DayOfTheWeek => mapping (NumberOfLesson => uint)) table;
  mapping (uint => mapping (DayOfTheWeek => NumberOfLesson)) courseEntry;

  constructor() {}

  function insertCourse(uint _courseId, DayOfTheWeek day, NumberOfLesson time) public {
    table[day][time] = _courseId;
  }

  function deleteCourse(DayOfTheWeek day, NumberOfLesson time) public {
    delete table[day][time];
  }

  function getCourseId(DayOfTheWeek day, NumberOfLesson time) public view returns (uint) {
    return table[day][time];
  }

  function getWholeTable() public view returns (uint[7][9] memory) {
    uint[7][9] memory entries;
    for (uint i = 0; i < 7; i++) {
      for (uint j = 1; j < 9; j++) {
        entries[i][j] = getCourseId(DayOfTheWeek(i), NumberOfLesson(j));
      }
    }
    return entries;
  }

  function getTable(uint[] memory courses) public view returns (uint[7][9] memory) {
    uint[7][9] memory entries;
    if (courses.length == 0)
      return entries;
    for (uint i = 0; i < 7; i++) {
      for (uint j = 1; j < 9; j++) {
        entries[i][j] = 0;
        if (isIncluded(getCourseId(DayOfTheWeek(i), NumberOfLesson(j)), courses))
          entries[i][j] = getCourseId(DayOfTheWeek(i), NumberOfLesson(j));
      }
    }
    return entries;
  }
  
  function isIncluded(uint courseId, uint[] memory courses) internal pure returns (bool) {
    for (uint i = 0; i < courses.length; i++) {
      if (courseId == courses[i])
        return true;
    }
    return false;
  }
}
