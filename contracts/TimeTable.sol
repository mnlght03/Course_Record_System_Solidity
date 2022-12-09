// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract TimeTable {
  enum DayOfTheWeek { SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY }
  enum NumberOfLesson { NONE, FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH }

  mapping (DayOfTheWeek => mapping (NumberOfLesson => uint)) public table;
  mapping (uint => mapping (DayOfTheWeek => NumberOfLesson[])) public courseEntries;

  constructor() {}

  function insertCourse(uint _courseId, uint day, uint numberOfLesson) public {
    require(day <= uint(DayOfTheWeek.SATURDAY), "day exceeds enum length");
    require(numberOfLesson <= uint(NumberOfLesson.EIGHTH), "numberOfLesson exceeds enum length");
    require(_courseId > 0, "CourseId should be greater than zero");
    table[DayOfTheWeek(day)][NumberOfLesson(numberOfLesson)] = _courseId;
    courseEntries[_courseId][DayOfTheWeek(day)].push(NumberOfLesson(numberOfLesson));
  }

  function deleteCourse(uint _courseId) public {
    for (uint i = 0; i < uint(DayOfTheWeek.SATURDAY); i++) {
      for (uint j = 0; j < courseEntries[_courseId][DayOfTheWeek(i)].length; j++) {
        NumberOfLesson numberOfLesson = courseEntries[_courseId][DayOfTheWeek(i)][j];
        delete table[DayOfTheWeek(i)][numberOfLesson];
      }
      delete courseEntries[_courseId][DayOfTheWeek(i)];
    }
  }

  function deleteEntity(uint day, uint numberOfLesson) public {
    require(day <= uint(DayOfTheWeek.SATURDAY), "day exceeds enum length");
    require(numberOfLesson <= uint(NumberOfLesson.EIGHTH), "numberOfLesson exceeds enum length");
    uint course = table[DayOfTheWeek(day)][NumberOfLesson(numberOfLesson)];
    delete table[DayOfTheWeek(day)][NumberOfLesson(numberOfLesson)];
    bool noMoreEntries = true;
    for (uint i = 0; i < courseEntries[course][DayOfTheWeek(day)].length; i++) {
      if (i == numberOfLesson) {
        courseEntries[course][DayOfTheWeek(day)][i] = NumberOfLesson.NONE;
        continue;
      }
      if (courseEntries[course][DayOfTheWeek(day)][i] != NumberOfLesson.NONE) {
        noMoreEntries = false;
        if (i < numberOfLesson)
          continue;
        else 
          break;
      }
    }
    if (noMoreEntries)
      delete courseEntries[course][DayOfTheWeek(day)];
  }

  function getCourseId(uint day, uint numberOfLesson) public view returns (uint) {
    require(day <= uint(DayOfTheWeek.SATURDAY), "day exceeds enum length");
    require(numberOfLesson <= uint(NumberOfLesson.EIGHTH), "numberOfLesson exceeds enum length");
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
