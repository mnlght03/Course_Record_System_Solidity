// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract TimeTable {
  enum DayOfTheWeek { SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY }
  enum NumberOfLesson { NONE, FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH }

  mapping (DayOfTheWeek => mapping (NumberOfLesson => uint)) public table;
  mapping (uint => mapping (DayOfTheWeek => NumberOfLesson)) public courseEntry;

  constructor() {}

  function insertCourse(uint _courseId, uint8 day, uint8 numberOfLesson) public {
    require(_courseId > 0, "CourseId should be greater than zero");
    table[DayOfTheWeek(day)][NumberOfLesson(numberOfLesson)] = _courseId;
    courseEntry[_courseId][DayOfTheWeek(day)] = NumberOfLesson(numberOfLesson);
  }

  function deleteCourse(uint8 day, uint8 numberOfLesson) public {
    uint course = table[DayOfTheWeek(day)][NumberOfLesson(numberOfLesson)];
    delete table[DayOfTheWeek(day)][NumberOfLesson(numberOfLesson)];
    delete courseEntry[course][DayOfTheWeek(day)];
  }

  function getCourseId(uint8 day, uint8 numberOfLesson) public view returns (uint) {
    return table[DayOfTheWeek(day)][NumberOfLesson(numberOfLesson)];
  }

  function getWholeTable() public view returns (uint[][] memory) {
    uint[][] memory entries = new uint[][](7);
    for (uint8 i = 0; i < 7; i++) {
      entries[i] = new uint[](9);
      for (uint8 j = 1; j < 9; j++) {
        entries[i][j] = getCourseId(i, j);
      }
    }
    return entries;
  }

  function getTable(uint[] memory courses) public view returns (uint[][] memory) {
    uint[][] memory entries = new uint[][](7);
    if (courses.length == 0)
      return entries;
    for (uint8 i = 0; i < 7; i++) {
      entries[i] = new uint[](9);
      for (uint8 j = 1; j < 9; j++) {
        if (isIncluded(getCourseId(i, j), courses))
          entries[i][j] = getCourseId(i, j);
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
