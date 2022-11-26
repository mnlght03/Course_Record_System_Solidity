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

  function getTable(uint[] courses) public returns (uint8[7][9] entries) {
    if (courses.length == 0)
      return;
    mapping (uint => bool) memory isIncluded;
    for (uint i = 0; i < courses.length; i++)
      isIncluded[courses[i]] = true;
    for (uint i = 0; i < 7; i++) {
      for (uint j = 1; j < 9; j++) {
        if (isIncluded(getCourseId(DayOfTheWeek(i), NumberOfLesson(j))))
          entries[i][j] = getCourseId(DayOfTheWeek(i), NumberOfLesson(j));
      }
    }
  }
}
