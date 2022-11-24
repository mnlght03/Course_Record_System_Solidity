// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Teacher {
  address public addr;
  bool public teaches;
  uint public teacherId;
  uint[] public courseIds;
  uint public totalCourses;
  mapping (uint => bool) coursesTaught;
  // @dev courseId => groupIds[]
  mapping (uint => uint[]) public courseGroups;

  constructor(address _addr, uint _id) {
    addr = _addr;
    teaches = true;
    teacherId = _id;
  }

  function getAddress() public view returns (address) {
    return addr;
  }

  function getId() public view returns (uint) {
    return teacherId;
  }

  function teachesCourse(uint _courseId) public view returns (bool) {
    return coursesTaught[_courseId];
  }

  function teachesCourseToGroup(uint _courseId, uint _groupId) public view returns (bool) {
    if (!teachesCourse(_courseId))
      return false;
    uint[] memory groups = courseGroups[_courseId];
    for (uint i = 0; i < groups.length; i++)
      if (_groupId == groups[i])
        return true;
    return false;
  }
  
  function assignToCourse(uint _courseId, uint[] memory groups) public {
    courseIds.push(_courseId);
    coursesTaught[_courseId] = true;
    courseGroups[_courseId] = groups;
    totalCourses++;
  }

  function addGroupToCourse(uint _courseId, uint _groupId) public {
    // getGroupIds(_courseId).push(_groupId);
    courseGroups[_courseId].push(_groupId);
  }

  function getGroupIds(uint _courseId) public view returns (uint[] memory) {
    require(teachesCourse(_courseId));
    return courseGroups[_courseId];
  }

  function unassignFromCourse(uint _courseId) public {
    if (!teachesCourse(_courseId))
      return;
    for (uint i = 0; i < courseIds.length; i++)
      if (courseIds[i] == _courseId) {
        delete courseIds[i];
        break;
      }
    coursesTaught[_courseId] = false;
    totalCourses--;
  }

  function deleteGroupFromCourse(uint _groupId) public {
    
  }


  // Below functions should be in main contract

  // function markAttendance(Student student, uint _courseId, uint256 date, bool attendanceStatus) public {
  //   require(teachesCourseToGroup(_courseId, student.groupId()));
  //   require(student.isEnrolled(_courseId));
  //   student.setAttendance(_courseId, date, attendanceStatus);
  //   emit MarkedAttendance(addr, student.addr(), _courseId, date, attendanceStatus);
  // }

  // function setGrade(Student student, uint _courseId, uint256 date, uint256 grade) public {
  //   require(teachesCourseToGroup(_courseId, student.groupId()));
  //   require(student.isEnrolled(_courseId));
  //   student.setGrade(_courseId, date, grade);
  //   emit SetGrade(addr, student.addr(), _courseId, date, grade);
  // }
}