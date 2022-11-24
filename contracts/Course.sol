// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Course {
  struct CourseInfo {
    string name;
    uint[] teacherIds;
    uint courseId;
    bool available;
  }

  CourseInfo public courseInfo;

  constructor(string memory courseName, uint id) {
    courseInfo.name = courseName;
    courseInfo.courseId = id;
    courseInfo.available = true;
  }

  function getCourseInfo() public view returns (CourseInfo memory) {
    return courseInfo;
  }

  function getCourseName() public view returns (string memory) {
    return courseInfo.name;
  }

  function getCourseId() public view returns (uint) {
    return courseInfo.courseId;
  }

  function isAvailabe() public view returns (bool) {
    return courseInfo.available;
  }

  function getCourseTeachersIds() public view returns (uint[] memory teachers) {
    uint idx = 0;
    for (uint i = 0; i < courseInfo.teacherIds.length; i++) {
      if (courseInfo.teacherIds[i] != 0)
        teachers[idx++] = courseInfo.teacherIds[i];
    }
    // courseInfo.teacherIds = teachers;  // is this a good practice to remove zeroed teachers from teacherIds[] ?
  }
}