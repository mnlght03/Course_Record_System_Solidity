// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "./AdminList.sol";
import "./StudentList.sol";
import "./TeacherList.sol";
import "./CourseList.sol";
import "./TimeTable.sol";
import "./GradeBook.sol";
import "./GroupList.sol";

contract Main {
  enum Roles{ NONE, SUPERADMIN, ADMIN, TEACHER, STUDENT }
  mapping (address => Roles) roles;
  AdminList adminList = new AdminList();
  constructor() {
    roles[msg.sender] = Roles.SUPERADMIN;
    adminList.addAdmin(msg.sender);
  }

  function isSuperAdmin(address _addr) public view returns (bool) {
    return roles[_addr] == Roles.SUPERADMIN;
  }
  function isAdmin(address _addr) public view returns (bool) {
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

  modifier onlyStudent() {
    require(isStudent(msg.sender), "Only student can do this");
    _;
  }

  TeacherList public teacherList = new TeacherList();
  StudentList public studentList = new StudentList();
  CourseList public courseList = new CourseList();
  GroupList public groupList = new GroupList();

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
    adminList.deleteAdmin(adminAddr);
    emit AdminDeleted(msg.sender, adminAddr);
  }

  event NewGroup(address initiator, uint groupId);
  event GroupDeleted(address initiator, uint groupId);

  function addGroup(uint groupId) onlyAdmin public {
    groupList.addGroup(groupId);
    emit NewGroup(msg.sender, groupId);
  }

  function deleteGroup(uint groupId) onlyAdmin public {
    groupList.deleteGroup(groupId);
    emit GroupDeleted(msg.sender, groupId);
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
    require(teacherList.getTeacherByAddress(teacherAddress).teachesCourse(_courseId));
    teacherList.unassignTeacherFromCourse(teacherAddress, _courseId);
    emit TeacherUnassignedFromCourse(msg.sender, teacherAddress, _courseId);
  }

  event GroupAssignedToTeacher(address initiator, uint groupId, uint courseId, address teacherAddress);
  event GroupUnassignedFromTeacher(address initiator, uint groupId, uint courseId, address teacherAddress);

  function assignGroupToCourseTeacher(uint _groupId, uint _courseId, address teacherAddress) onlyAdmin public {
    require(isTeacher(teacherAddress));
    require(groupList.groupExists(_groupId));
    require(courseList.courseExists(_courseId));
    teacherList.assignGroupToCourseTeacher(teacherAddress, _groupId, _courseId);
    groupList.setCourseTeacher(_groupId, _courseId, teacherAddress);
    emit GroupAssignedToTeacher(msg.sender, _groupId, _courseId, teacherAddress);
  }

  function unassignGroupFromCourseTeacher(uint _groupId, uint _courseId, address teacherAddress) onlyAdmin public {
    require(isTeacher(teacherAddress));
    require(groupList.groupExists(_groupId));
    require(courseList.courseExists(_courseId));
    require(teacherList.getTeacherByAddress(teacherAddress).teachesCourseToGroup(_courseId, _groupId));
    teacherList.unassignGroupFromCourseTeacher(teacherAddress, _groupId, _courseId);
    groupList.deleteCourseTeacher(_groupId, _courseId);
    emit GroupUnassignedFromTeacher(msg.sender, _groupId, _courseId, teacherAddress);
  }

  event NewStudent(address initiator, address newStudentAddr, uint groupId);
  event StudentDeleted(address initiator, address deletedAddr, uint groupId);

  function addStudent(address newStudentAddr, uint _groupId) onlyAdmin public {
    require(newStudentAddr != address(0));
    require(groupList.groupExists(_groupId));
    roles[newStudentAddr] = Roles.STUDENT;
    studentList.addStudent(newStudentAddr, _groupId);
    emit NewStudent(msg.sender, newStudentAddr, _groupId);
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
    groupList.deleteStudent(studentAddress, oldGroup);
    groupList.addStudent(studentAddress, newGroup);
    emit ChangedStudentGroup(msg.sender, studentAddress, oldGroup, newGroup);
  }

  event StudentAddedToCourse(address initiator, address studentAddress, uint courseId);
  event StudentDeletedFromCourse(address initiator, address studentAddress, uint courseId);

  function addStudentToCourse(address studentAddress, uint courseId) onlyAdminOrTeacher public {
    require(isStudent(studentAddress));
    require(courseList.courseExists(courseId));
    require(courseList.getCourse(courseId).availableForGroup(studentList.getStudentGroupId(studentAddress)),
            "Course is unavailable for this group");
    studentList.addStudentToCourse(studentAddress, courseId);
    emit StudentAddedToCourse(msg.sender, studentAddress, courseId);
  }

  function deleteStudentFromCourse(address studentAddress, uint courseId) onlyAdminOrTeacher public {
    require(isStudent(studentAddress));
    studentList.deleteStudentFromCourse(studentAddress, courseId);
    emit StudentDeletedFromCourse(msg.sender, studentAddress, courseId);
  }

  event NewCourse(address initiator, uint courseId, string courseName);
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

  event NewCourseRequest(address student, address teacher, uint courseId);
  event RequestAccepted(address teacher, address student, uint courseId);
  event RequestDeclined(address teacher, address student, uint courseId);

  function requestToJoinCourse(uint courseId) onlyStudent public {
    require(courseList.courseExists(courseId), "Course doesn't exist");
    uint groupId = studentList.getStudentGroupId(msg.sender);
    require(courseList.courseAvailableForGroup(courseId, groupId), "Course unavailable for group");
    address teacher = teacherList.getCourseTeacher(courseId, groupId);
    require(teacher != address(0), "Course teacher not found");
    teacherList.sendRequest(msg.sender, teacher, courseId);
    emit NewCourseRequest(msg.sender, teacher, courseId);
  }

  function acceptRequest(address student, uint courseId) onlyTeacher public {
    require(student != address(0));
    require(courseList.courseExists(courseId), "Course doesn't exist");
    studentList.addStudentToCourse(student, courseId);
    teacherList.deleteRequest(msg.sender, student, courseId);
    emit RequestAccepted(msg.sender, student, courseId);
  }

  function declineRequest(address student, uint courseId) onlyTeacher public {
    require(student != address(0));
    require(courseList.courseExists(courseId), "Course doesn't exist");
    teacherList.deleteRequest(msg.sender, student, courseId);
    emit RequestDeclined(msg.sender, student, courseId);
  }

  event CourseAvailableForGroup(uint courseId, uint groupId);
  event CourseUnavailableForGroup(uint courseId, uint groupId);

  function makeCourseAvailableForGroup(uint courseId, uint groupId) onlyAdmin public {
    require(courseList.courseExists(courseId));
    courseList.makeCourseAvailableForGroup(courseId, groupId);
    emit CourseAvailableForGroup(courseId, groupId);
  }

  function makeCourseUnavailableForGroup(uint courseId, uint groupId) onlyAdmin public {
    require(courseList.courseExists(courseId));
    courseList.makeCourseUnavailableForGroup(courseId, groupId);
    emit CourseUnavailableForGroup(courseId, groupId);
  }

  TimeTable timeTable = new TimeTable();
  GradeBook gradeBook = new GradeBook();

  function isNullAddress(address addr) internal pure returns (bool) {
    return addr == address(0);
  }

  function courseApprovedForTimetable(uint courseId, address studentAddress, address teacherAddress) internal view returns (bool) {
    return (isNullAddress(studentAddress) && isNullAddress(teacherAddress) ||
            isNullAddress(studentAddress) &&
            teacherList.getTeacherByAddress(teacherAddress).teachesCourse(courseId) ||
            isNullAddress(teacherAddress) &&
            studentList.getStudentByAddress(studentAddress).studiesCourse(courseId) ||
            studentList.getStudentByAddress(studentAddress).studiesCourse(courseId) &&
            teacherList.getTeacherByAddress(teacherAddress).teachesCourse(courseId));
  }

  // @dev specify id = 0 to show for all ids
  function getTimeTable(uint courseId, address studentAddress, address teacherAddress) public view returns (uint[7][9] memory) {
    require(courseId == 0 || courseList.courseExists(courseId), "Course doesn't exist");
    require(studentAddress == address(0) || isStudent(studentAddress));
    require(teacherAddress == address(0) || isTeacher(teacherAddress));
    uint[] memory courses;
    uint coursesIdx = 0;
    uint[7][9] memory res;
    if (courseId != 0) {
      if (courseApprovedForTimetable(courseId, studentAddress, teacherAddress))
        courses[coursesIdx++] = courseId;
      else
        return res; // empty array
    }
    else if (studentAddress != address(0) || teacherAddress != address(0)) {
      for (uint i = 0; i < courseList.getListLength(); i++) {
        uint id = i + 1;
        if (courseList.courseExists(id) && courseApprovedForTimetable(id, studentAddress, teacherAddress))
          courses[coursesIdx++] = id;
      }
      res =  timeTable.getTable(courses);
    }
    else 
      res = timeTable.getWholeTable();
    return res;
  }

  function getGradeBook(uint courseId, address studentAddress, uint startDate, uint endDate) public view returns (GradeBook.Entry[] memory) {
    require(courseId == 0 || courseList.courseExists(courseId), "Course doesn't exist");
    require(studentAddress == address(0) || isStudent(studentAddress), "Address is not a student address");
    require(startDate <= endDate);
    return gradeBook.getBook(courseId, studentAddress, startDate, endDate);
  }

  function getAverageScore(uint courseId, address studentAddress) public view returns (uint) {
    require(courseList.courseExists(courseId), "Course doesn't exist");
    require(isStudent(studentAddress));
    return gradeBook.getAverageScore(studentAddress, courseId);
  }

  function getAverageAttendance(uint courseId, address studentAddress) public view returns (uint) {
    require(courseList.courseExists(courseId), "Course doesn't exist");
    require(isStudent(studentAddress));
    return gradeBook.getAverageAttendance(studentAddress, courseId);
  }

  event CourseInsertedInTimeTable(address initiator, uint courseId, uint8 day, uint8 numberOfLesson);
  event CourseDeletedFromTimeTable(address initiator, uint courseId, uint8 day, uint8 numberOfLesson);
  event ChangedCourseInTimeTable(address inititator, uint oldCourse, uint newCourse, uint8 day, uint8 numberOfLesson);

  function insertCourseInTimetable(uint courseId, uint8 day, uint8 numberOfLesson) onlyAdmin public {
    require(courseList.courseExists(courseId));
    timeTable.insertCourse(courseId, day, numberOfLesson);
    emit CourseInsertedInTimeTable(msg.sender, courseId, day, numberOfLesson);
  }

  function deleteCourseFromTimetable(uint8 day, uint8 numberOfLesson) onlyAdmin public {
    uint courseId = timeTable.getCourseId(day, numberOfLesson);
    timeTable.deleteCourse(day, numberOfLesson);
    emit CourseDeletedFromTimeTable(msg.sender, courseId, day, numberOfLesson);
  }

  function changeCourseInTimetable(uint8 day, uint8 numberOfLesson, uint newCourse) onlyAdmin public {
    require(courseList.courseExists(newCourse));
    uint oldCourse = timeTable.getCourseId(day, numberOfLesson);
    timeTable.insertCourse(newCourse, day, numberOfLesson);
    emit ChangedCourseInTimeTable(msg.sender, oldCourse, newCourse, day, numberOfLesson);
  }

  event MarkedAttendance(address teacher, address student, uint courseId, uint date, bool status);
  event AssignmentRated(address teacher, address student, uint courseId, uint date, uint8 grade);

  function markAttendance(uint date, uint courseId, address studentAddress, bool status) onlyTeacher public {
    require(teacherList.getTeacherByAddress(msg.sender).teachesCourse(courseId));
    require(studentList.getStudentByAddress(studentAddress).studiesCourse(courseId));
    gradeBook.markAttendance(date, courseId, studentAddress, status);
    emit MarkedAttendance(msg.sender, studentAddress, courseId, date, status);
  }

  function rateAssignment(uint date, uint courseId, address studentAddress, uint8 grade) onlyTeacher public {
    require(teacherList.getTeacherByAddress(msg.sender).teachesCourse(courseId));
    require(studentList.getStudentByAddress(studentAddress).studiesCourse(courseId));
    gradeBook.rateAssignment(date, courseId, studentAddress, grade);
    emit AssignmentRated(msg.sender, studentAddress, courseId, date, grade);
  }
}
