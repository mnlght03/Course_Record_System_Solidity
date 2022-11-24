// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Student {
  address public addr;
  constructor(address _addr) {
    addr = _addr;
  }
  mapping (string => bool) courses;
  mapping (string => mapping (uint256 => uint256)) grades;
  mapping (string => mapping (uint256 => bool)) attendance;
  function requestToJoinCourse(string calldata courseName, address teacher) public {
    
  }
  function isEnrolled(string calldata courseName) public view returns (bool) {
    return courses[courseName];
  }
  function setGrade(string calldata courseName, uint256 date, uint256 grade) public {
    grades[courseName][date] = grade;
  }
  function setAttendance(string calldata courseName, uint256 date, bool attendanceStatus) public {
    attendance[courseName][date] = attendanceStatus;
  }
}