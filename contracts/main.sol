// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "./Admin.sol";
import "./Student.sol";
import "./Teacher.sol";
import "./Course.sol";

contract Main {
  enum Roles{ NONE, SUPERADMIN, ADMIN, TEACHER, STUDENT }
  enum DayOfTheWeek{ SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY }
  mapping (address => Roles) roles;
  constructor() {
    roles[msg.sender] = Roles.SUPERADMIN;
    admins.push(new Administrator(msg.sender, 0));
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
  modifier onlySuperAdmin() {
    require(isSuperAdmin(msg.sender), "Only contract creator can do this");
    _;
  }

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

  Administrator[] public admins;
  mapping (address => uint) adminsIdMapping;
  
  //  TODO: add same functions for admin and students
  //        and decompose those arrays to separate contracts 
  Teacher[] public teachers;
  mapping (address => uint) teachersIdMapping;
  
  function getTeacherById(uint _teacherId) public view returns (Teacher) {
    require(_teacherId > 0 && _teacherId <= teachers.length);
    return teachers[_teacherId - 1];
  }

  function getTeacherIdByAddress(address _addr) public view returns (uint) {
    require(isTeacher(_addr));
    return teachersIdMapping[_addr];
  }

  function getTeacherByAddress(uint _addr) public view returns (Teacher) {
    return getTeacherById(getTeacherIdByAddress(_addr));
  }


  Student[] public students;
  mapping (address => uint) studentsIdMapping;

  function getStudentById(uint _studentId) public view returns (Student) {
    require(_studentId > 0 && _studentId <= students.length);
    return students[_studentId - 1];
  }


  Course[] public courses;
  // courseName => courseId
  mapping (string => uint) courseIdMapping;
  
  function getCourseById(uint _courseId) public view returns (Course) {
    require(_courseId > 0 && _courseId <= courses.length);
    return courses[_courseId - 1];
  }

  function getCourseInfo(uint _courseId) public view returns (Course.CourseInfo) {
    return getCourseById(_courseId).getCourseInfo();
  }

  function courseIsAvailable(uint _courseId) public view returns (bool available) {
    return getCourseById(_courseId).isAvailable();
  }

  function courseExists(string memory courseName) internal returns (bool) {
    return courseIdMapping[courseName] != 0;
  }

  function courseExists(uint _courseId) internal returns (bool) {
    return _courseId > 0 && _courseId <= courses.length && courseExists(getCourseById(_courseId).getCourseName());
  }

  function getCourseTeachersIds(uint _courseId) public view returns (uint[] memory teacherIds) {
    return getCourseById(_courseId).getCourseTeachersIds();
  }

  function getCourseTeachers(uint _courseId) public view returns (Teacher[] memory courseTeachers) {
    uint[] memory teacherIds = getCourseTeachersIds(_courseId);
    for (uint i = 0; i < teacherIds.length; i++) {
      courseTeachers[i] = getTeacherById(teacherIds[i]);
    }
  }

  struct StudentGroup {
    uint groupId;
    uint[] studentIds;
    bool exists;
  }
  
  event NewAdmin(address initiator, address newAdminAddr);
  event AdminDeleted(address initiator, address deletedAddr);

  event NewTeacher(address initiator, address newTeacherAddr);
  event TeacherDeleted(address initiator, address deletedAddr);
  event TeacherAssignedToCourse(address initiator, address teacherAddress, uint courseId);
  event TeacherUnassignedFromCourse(address initiator, address teacherAddress, uint courseId);

  event NewStudent(address initiator, address newStudentAddr);
  event StudentDeleted(address initiator, address deletedAddr);

  event NewCourse(address initiator, uint courseId);
  event CourseDeleted(address initiator, uint courseId, string courseName);

  function addAdmin(address newAdminAddr) onlyAdmin public {
    require(newAdminAddr != address(0));
    roles[newAdminAddr] = Roles.ADMIN;
    admins.push(new Administrator(newAdminAddr, admins.length));
    emit NewAdmin(msg.sender, newAdminAddr);
  }

  function deleteAdmin(address adminAddr) onlySuperAdmin public {
    require(isAdmin(adminAddr));
    roles[adminAddr] = Roles.NONE;
    delete admins[getAdminByAddress(adminAddr).getId()];
    emit AdminDeleted(msg.sender, adminAddr);
  }

  function addTeacher(address newTeacherAddr) onlyAdmin public {
    require(newTeacherAddr != address(0));
    uint teacherId = teachers.length + 1;
    teachers.push(new Teacher(newTeacherAddr, teacherId));
    roles[newTeacherAddr] = Roles.TEACHER;
    emit NewTeacher(msg.sender, newTeacherAddr);
  }

  function assignTeacherToCourse(Teacher _teacher, uint _courseId, uint[] _groups) onlyAdmin public {
    require(_courseId > 0 && _courseId <= courses.length);
    _teacher.assignToCourse(_courseId, _groups);
    courses[_courseId - 1].courseInfo.teacherIds.push(_teacher.getId());
    emit TeacherAssignedToCourse(msg.sender, _teacher.addr(), _courseId);
  }
  
  function unassignTeacherFromCourse(Teacher _teacher, uint _courseId) onlyAdmin public {
    require(_courseId > 0 && _courseId <= courses.length);
    _teacher.unassignFromCourse(_courseId);
    deleteTeacherIdFromCourse(_teacher.getId(), _courseId);
    emit TeacherUnassignedFromCourse(msg.sender, _teacher.addr(), _courseId);
  }

  function deleteTeacherIdFromCourse(uint _teacherId, uint _courseId) internal {
    uint[] storage ids = courses[_courseId - 1].courseInfo.teacherIds;
    for (uint i = 0; i < ids.length; i++)
      if (ids[i] == _teacherId) {
        delete ids[i];
        break;
      }
  }

  // function deleteTeacher(uint _teacherId) public {

  // }

  function addStudent(address newStudentAddr, uint _groupId) onlyAdmin public {
    require(newStudentAddr != address(0));
    require(groupExists(_groupId));
    uint _studentId = students.length + 1;
    students.push(new Student(newStudentAddr, _studentId, _groupId));
    roles[newStudentAddr] = Roles.STUDENT;
    emit NewStudent(msg.sender, newStudentAddr);
  }

  function addCourse(string memory courseName) onlyAdmin public {
    require(!courseExists(courseName));
    uint id = courses.length + 1;
    courses.push(new Course(courseName, id));
    courseIdMapping[courseName] = id;
    emit NewCourse(msg.sender, id);
  }

  function deleteCourse(uint _courseId) onlyAdmin public {
    require(courseExists(_courseId));
    string memory courseName = getCourseById(_courseId).getCourseName();
    delete courseIdMapping[courseName];
    delete courses[_courseId - 1];
    // delete course from all users
    emit CourseDeleted(msg.sender, _courseId, courseName);
  }

  function makeCourseUnavailable(uint _courseId) onlyAdmin public {
    require(courseExists(_courseId));
  }
}