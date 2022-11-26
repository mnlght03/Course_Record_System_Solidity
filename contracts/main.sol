// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "./AdminList.sol";
import "./StudentList.sol";
import "./TeacherList.sol";
import "./CourseList.sol";
import "./TimeTable.sol";
import "./GradeBook.sol";

contract Main {
  enum Roles{ NONE, SUPERADMIN, ADMIN, TEACHER, STUDENT }
  mapping (address => Roles) roles;
  AdminList adminList;
  constructor() {
    roles[msg.sender] = Roles.SUPERADMIN;
    adminList.addAdmin(new Administrator(msg.sender, 0));
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

  TeacherList public teacherList;
  StudentList public studentList;
  CourseList public courseList;

  event NewAdmin(address initiator, address newAdminAddr);
  event AdminDeleted(address initiator, address deletedAddr);

  function addAdmin(address newAdminAddr) onlyAdmin public {
    require(newAdminAddr != address(0));
    roles[newAdminAddr] = Roles.ADMIN;
    adminList.addAdmin(newAdminAddr);
    emit NewAdmin(msg.sender, newAdminAddr);
  }

  function deleteAdmin(address adminAddr) onlySuperAdmin public {
    require(isAdmin(adminAddr));
    roles[adminAddr] = Roles.NONE;
    delete admins[getAdminByAddress(adminAddr).getId()];
    emit AdminDeleted(msg.sender, adminAddr);
  }

  event NewTeacher(address initiator, address newTeacherAddr);
  event TeacherDeleted(address initiator, address deletedAddr);

  function addTeacher(address newTeacherAddr) onlyAdmin public {
    require(newTeacherAddr != address(0));
    teacherList.addTeacher(newTeacherAddr);
    roles[newTeacherAddr] = Roles.TEACHER;
    emit NewTeacher(msg.sender, newTeacherAddr);
  }

  function deleteTeacher(address teacherAddress) onlyAdmin public {
    require(isTeacher(teacherAddress));
    teacherList.deleteTeacher(teacherAddress);
    roles[teacherAddress] = Roles.NONE;
    emit TeacherDeleted(msg.sender, teacherAddress);
  }

  event TeacherAssignedToCourse(address initiator, address teacherAddress, uint courseId);
  event TeacherUnassignedFromCourse(address initiator, address teacherAddress, uint courseId);

  function assignTeacherToCourse(address teacherAddress, uint _courseId) onlyAdmin public {
    require(isTeacher(teacherAddress));
    teacherList.assignTeacherToCourse(teacherAddress, _courseId);
    emit TeacherAssignedToCourse(msg.sender, teacherAddress, _courseId);
  }

  function unassignTeacherFromCourse(address teacherAddress, uint _courseId) onlyAdmin public {
    require(isTeacher(teacherAddress));
    require(teacherList.getTeacherByAddres(teacherAddress).teachesCourse(_courseId));
    teacherList.unassignTeacherFromCourse(teacherAddress, _courseId);
    emit TeacherUnassignedToCourse(msg.sender, teacherAddress, _courseId);
  }

  event GroupAssignedToTeacher(address initiator, uint groupId, uint courseId, address teacherAddress);
  event GroupUnassignedFromTeacher(address initiator, uint groupId, uint courseId, address teacherAddress);

  function assignGroupToCourseTeacher(uint _groupId, uint _courseId, address teacherAddress) onlyAdmin public {
    require(isTeacher(teacherAddress));
    require(groupExists(_groupId));
    require(courseList.courseExists(_courseId));
    teacherList.assignGroupToCourseTeacher(teacherAddress, _groupId, _courseId);
    emit GroupAssignedToTeacher(msg.sender, _groupId, _courseId, teacherAddress);
  }

  function unassignGroupFromCourseTeacher(uint _groupId, uint _courseId, address teacherAddress) onlyAdmin public {
    require(isTeacher(teacherAddress));
    require(groupExists(_groupId));
    require(courseList.courseExists(_courseId));
    require(teacherList.getTeacherByAddres(teacherAddress).teachesCourseToGroup(_courseId, _groupId));
    teacherList.unassignGroupFromCourseTeacher(teacherAddress, _groupId, _courseId);
    emit GroupUnassignedFromTeacher(msg.sender, _groupId, _courseId, teacherAddress);
  }

  event NewStudent(address initiator, address newStudentAddr, uint groupId);
  event StudentDeleted(address initiator, address deletedAddr, uint groupId);

  function addStudent(address newStudentAddr, uint _groupId) onlyAdmin public {
    require(newStudentAddr != address(0));
    require(groupExists(_groupId));
    roles[newStudentAddr] = Roles.STUDENT;
    studentList.addStudent(newStundetAddr, _groupId);
    emit NewStudent(msg.sender, newStudentAddr);
  }

  function deleteStudent(address studentAddress) onlyAdmin public {
    require(isStudent(studentAddress));
    uint groupId = studentList.getStudentGroupId(studentAddress);
    studentList.deleteStudent(studentAddress);
    roles[studentAddress] = Roles.NONE;
    emit StudentDeleted(msg.sender, studentAddress, groupId);
  }

  event ChangedStudentGroup(address initiator, address studentAddress, uint oldGroupId, uint newGroupId);

  function changeStudentGroup(address studentAddress, uint newGroup) onlyAdmin public {
    require(isStudent(studentAddress));
    uint oldGroup = studentList.getStudentGroupId(studentAddress);
    studentList.changeStudentGroup(studentAddress, newGroup);
    emit ChangedStudentGroup(msg.sender, studentAddress, oldGroup, newGroup);
  }

  event StudentAddedToCourse(address initiator, address studentAddress, uint courseId);
  event StudentDeletedFromCourse(address initiator, address studentAddress, uint courseId);

  function addStudentToCourse(address studentAddress, uint courseId) onlyAdminOrTeacher public {
    require(isStudent(studentAddress));
    require(courseList.courseExists(courseId));
    require(courseList.getCourse(courseId).isAvailableForGroup(studentList.getStudentGroup(studentAddress)),
            "Course is unavailable for this group");
    studentList.addStudentToCourse(studentAddress, courseId);
    emit StudentAddedToCourse(msg.sender, studentAddress, courseId);
  }

  function deleteStudentFromCourse(address studentAddress, uint courseId) onlyAdminOrTeacher public {
    require(isStudent(studentAddress));
    studentList.deleteStudentFromCourse(studentAddress, courseId);
    emit StudentDeletedFromCourse(msg.sender, studentAddress, courseId);
  }

  event NewCourse(address initiator, uint courseId, uint courseName);
  event CourseDeleted(address initiator, uint courseId, string courseName);

  function addCourse(string memory courseName) onlyAdmin public {
    courseList.addCourse(courseName);
    emit NewCourse(msg.sender, courseList.getCourseId(courseName), courseName);
  }

  function deleteCourse(uint _courseId) onlyAdmin public {
    string memory name = courseList.getCourseName(_courseId);
    courseList.deleteCourse(_courseId);
    // TODO : delete course from all users
    emit CourseDeleted(msg.sender, _courseId, name);
  }


  TimeTable timeTable;
  GradeBook gradeBook;

  function isNullAddress(address addr) internal bool returns (bool) {
    return addr == address(0);
  }

  function courseApprovedForTimetable(uint courseId, address studentAddress, address teacherAddress) internal view returns (bool) {
    return (isNullAddress(studentAddress) && isNullAddress(teacherAddress) ||
            isNullAddress(studentAddress) &&
            teacherList.getTeacherByAddres(teacherAddress).teachesCourse(courseId) ||
            isNullAddress(teacherAddress) &&
            studentList.getStudentByAddress(studentAddress).studiesCourse(courseId) ||
            studentList.getStudentByAddress(studentAddress).studiesCourse(courseId) &&
            teacherList.getTeacherByAddres(teacherAddress).teachesCourse(courseId));
  }

  // @dev specify id = 0 to show for all ids
  function getTimeTable(uint courseId, address studentAddress, address teacherAddress) public view returns (uint[7][9]) {
    require(courseId == 0 || courseList.courseExists(courseId), "Course doesn't exist");
    require(studentAddress == address(0) || isStudent(studentAddress));
    require(teacherAddress == address(0) || isTeacher(teacherAddress));
    uint[] memory courses;
    if (courseId != 0 && courseApprovedForTimetable(courseId, studentAddress, teacherAddress)) {
          courses.push(courseId);
    }
    else {
      for (uint i = 0; i < courseList.list().length; i++) {
        if (courseList[i].exists() && courseApprovedForTimetable(courseList[i]))
          courses.push(courseList[i].getId());
      }
    }
    return timeTable.getTable(courses);
  }

  function getGradeBook(uint courseId, address studentAddress, address teacherAddress, uint startDate, uint endDate) public view {
    require(courseId == 0 || courseList.courseExists(courseId), "Course doesn't exist");
    require(studentAddress == address(0) || isStudent(studentAddress));
    require(teacherAddress == address(0) || isTeacher(teacherAddress));
    require(startDate <= endDate);
    gradeBook.getBook(courseId, studentAddress, teacherAddress, startDate, endDate);
  }

  function getAverageScore(uint courseId, address studentAddress, uint groupId) public view returns (uint) {
    require(courseId == 0 || courseList.courseExists(courseId), "Course doesn't exist");
    require(studentAddress == address(0) || isStudent(studentAddress));
    return gradeBook.getAverageScore(courseId, studentAddress, groupId);
  }

  function getAverageAttendance(uint courseId, address studentAddress, uint groupId) public view returns (uint) {
    require(courseId == 0 || courseList.courseExists(courseId), "Course doesn't exist");
    require(studentAddress == address(0) || isStudent(studentAddress));
    return gradeBook.getAverageAttendance(courseId, studentAddress, groupId);
  }

  event CourseInsertedInTimeTable(address initiator, uint courseId, string day, string numberOfLesson);
  event CourseDeletedFromTimeTable(address initiator, uint courseId, string day, string numberOfLesson);
  event ChangedCourseInTimeTable(address inititator, uint oldCourse, uint newCourse, string day, string numberOfLesson);

  function insertCourseInTimetable(uint courseId, string calldata day, string calldata numberOfLesson) onlyAdmin public {
    require(courseList.courseExists(courseId));
    timeTable.insertCourse(courseId, day, numberOfLesson);
    emit CourseInsertedInTimeTable(msg.sender, courseId, day, numberOfLesson);
  }

  function deleteCourseFromTimetable(string calldata day, string calldata numberOfLesson) onlyAdmin public {
    uint courseId = timeTable.getCourseId(day, numberOfLesson);
    timeTable.deleteCourse(courseId, day, numberOfLesson);
    emit CourseDeletedFromTimetable(msg.sender, courseId, day, numberOfLesson);
  }

  function changeCourseInTimetable(string calldata day, string calldata numberOfLesson, uint newCourse) onlyAdmin public {
    require(courseList.courseExists(newCourse));
    uint oldCourse = timeTable.getCourseId(day, numberOfLesson);
    timeTable.insertCourse(newCourse, day, numberOfLesson);
    emit ChangedCourseInTimeTable(msg.sender, oldCourse, newCourse, day, numberOfLesson);
  }

  event MarkedAttendance(address teacher, address student, uint courseId, uint date, bool status);
  event AssignmentRated(address teacher, address student, uint courseId, uint date, uint8 grade);

  function markAttendance(uint courseId, address studentAddress, uint date, bool status) onlyTeacher public {
    require(teacherList.getTeacherByAddres(msg.sender).teachesCourse(courseId));
    require(studentList.getStudentByAddress(studentAddress).studiesCourse(studentId));
    // @dev teacherAddress (maybe not ?), studentAddress, date, status
    gradeBook.markAttendance(msg.sender, studentAddress, date, status);
    emit MarkedAttendance(msg.sender, studentAddress, courseId, date, status);
  }

  function rateAssignment(uint courseId, address studentAddress, uint date, string calldata grade) onlyTeacher public {
    require(teacherList.getTeacherByAddres(msg.sender).teachesCourse(courseId));
    require(studentList.getStudentByAddress(studentAddress).studiesCourse(courseId));
    gradeBook.rateAssignment(studentAddress, date, gradeBook.stringToGrade(grade));
    emit AssignmentRated(msg.sender, studentAddress, courseId, date, grade);
  }
}