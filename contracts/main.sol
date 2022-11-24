// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "./admin.sol";
import "./student.sol";
import "./teacher.sol";

contract Main {
  enum Roles{ NONE, SUPERADMIN, ADMIN, TEACHER, STUDENT }
  enum DayOfTheWeek{ SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY }
  mapping (address => Roles) roles;
  constructor() {
    roles[msg.sender] = Roles.SUPERADMIN;
    admins.push(msg.sender);
  }

  function isSuperAdmin(address _addr) public pure returns (bool) {
    return roles[_addr] == Roles.SUPERADMIN;
  }
  function isAdmin(address _addr) public pure returns (bool) {
    return roles[_addr] == Roles.ADMIN || roles[_addr] == Roles.SUPERADMIN;
  }
  function isTeacher(address _addr) public view returns (bool) {
    return roles[_addr] == Roles.TEACHER;
  }
  function isStudent(address _addr) public view returns (bool) {
    return roles[_addr] == Roles.STUDENT;
  }


  // @dev SuperAdmin a.k.a. contract creator can do anything
  modifier onlyAdmin() {
    require (isAdmin(msg.sender) || isSuperAdmin(msg.sender), "Only admin can do this");
    _;
  }

  modifier onlyTeacher() {
    require (isTeacher(msg.sender) || isSuperAdmin(msg.sender), "Only teacher can do this");
    _;
  }

  modifier onlyAdminOrTeacher() {
    require (isAdmin(msg.sender) || isTeacher(msg.sender)  || isSuperAdmin(msg.sender), "Only admin or teacher can do this");
    _;
  }

  address[] public admins;

  struct TeacherInfo {
    Teacher self;
    bool teaches;
    uint teacherId;
    uint[] courseIds;
    // @dev courseId => groupId
    mapping (uint => uint[]) courseGroups;
  }
  TeacherInfo[] public teachers;
  
  struct StudentInfo {
    Student self;
    bool studies;
    uint studentId;
    uint[] courseIds;
  }
  Student[] public students;

  struct CourseInfo {
    string name;
    uint[] teacherIds;
    uint totalTeachers;
    uint courseId;
    bool available;
  }
  mapping (string => uint) courseIdMapping;
  CourseInfo[] public courses;
  
  function courseIsAvailable(string calldata courseName) public view returns (bool available) {
    if (courseIdMapping[courseName] == 0)
      return false;
    return courses[courseIdMapping[courseName]].available;
  }

  event NewAdmin(address initiator, address newAdminAddr);
  event NewTeacher(address initiator, address newTeacherAddr);
  event NewStudent(address initiator, address newStudentAddr);

  function addAdmin(address newAdminAddr) onlyAdmin public {
    require(newAdminAddr != address(0));
    roles[newAdminAddr] = Roles.ADMIN;
    admins.push(newAdminAddr);
    emit NewAdmin(msg.sender, newAdminAddr);
  }

  function addTeacher(address newTeacherAddr, uint[] _courseIds) onlyAdmin public {
    require(newTeacherAddr != address(0));
    newTeacher = new Teacher(teacherAddr);
    for (uint i = 0; i < _courses.length; i++)
      assignTeacherToCourse(newTeacher, _courses[i]);
    teachers.push(newTeacher);
    roles[teacherAddr] = Roles.TEACHER;
    emit NewTeacher();
  }

  function assignTeacherToCourse(Teacher _teacher, string calldata courseName) onlyAdmin public {

    _teacher.assignToCourse(courseName);
  }

  function addStudent(address studentAddr) onlyAdmin public {
    students.push(new Student(studentAddr));
  }


  // @dev courseId => courseName
  mapping (uint256 => string) availableCourses;
  // @dev dayOfTheWeek (0 - 6) => classNumber(0 - 7) => courseName
  mapping (uint256 => mapping (uint256 => string)) schedule;
  // @dev courseName => courseTeachers
  mapping (string => Teacher[]) courseTeachers;
  

  
  function getCourseTeachers(string calldata courseName) returns (Teacher[] memory) {
    Teacher[] memory courseTeachers;
    for ()
  }

}