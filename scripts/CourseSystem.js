const fs = require("fs");
const Web3 = require("Web3");

const web3 = new Web3("http://127.0.0.1:8545");

const abi = JSON.parse(fs.readFileSync("../compiled_contracts/CourseSystem.abi").toString());

class CourseSystem {
  contractAddress = "0x391342f5acAcaaC9DE1dC4eC3E03f2678f7c78F1";
  signerAddress;
  privateKey;
  contract;

  constructor(addr, key) {
    signerAddress = addr;
    privateKey = key;
    contract = new web3.eth.Contract(abi, contractAddress, {
      from: signerAddress,
      gasPrice: "30000000000000"
    });
  }

  acceptRequest(studentAddress, courseId) {
    this.contract.methods.acceptRequest(studentAddress, courseId).send({from: signerAddress});
  }
  addAdmin(newAdmin) {
    this.contract.methods.addAdmin(newAdmin).send({from: signerAddress});
  }
  addCourse(courseName) {
    this.contract.methods.addCourse(courseName).send({from: signerAddress});
  }
  addGroup(groupId) {
    this.contract.methods.addGroup(groupId).send({from: signerAddress});
  }
  addStudent(newStudent) {
    this.contract.methods.addStudent(newStudent).send({from: signerAddress});
  }
  addStudentToCourse(studentAddress, courseId) {
    this.contract.methods.addStudentToCourse(studentAddress, courseId).send({from: signerAddress});
  }
  assignGroupToCourseTeacher(groupId, courseId, teacherAddress) {
    this.contract.methods.assignGroupToCourseTeacher(groupId, courseId, teacherAddress).send({from: signerAddress});
  }
  assignTeacherToCourse(teacherAddress, courseId) {
    this.contract.methods.assignTeacherToCourse(teacherAddress, courseId).send({from: signerAddress});
  }
  changeCourseInTimetable(day, numberOfLesson, newCourse) {
    this.contract.methods.changeCourseInTimetable(day, numberOfLesson, newCourse).send({from: signerAddress});
  }
  changeStudentGroup(studentAddress, newGroup) {
    this.contract.methods.changeStudentGroup(studentAddress, newGroup).send({from: signerAddress});
  }
  declineRequest(studentAddress, courseId) {
    this.contract.methods.declineRequest(studentAddress, courseId).send({from: signerAddress});
  }
  deleteAdmin(admin) {
    this.contract.methods.deleteAdmin(admin).send({from: signerAddress});
  }
  deleteCourse(courseId) {
    this.contract.methods.deleteCourse(courseId).send({from: signerAddress});
  }
  deleteCourseFromTimetable(day, numberOfLesson) {
    this.contract.methods.deleteCourseFromTimetable(day, numberOfLesson).send({from: signerAddress});
  }
  deleteGroup(groupId) {
    this.contract.methods.deleteGroup(groupId).send({from: signerAddress});
  }
  deleteStudent(studentAddress) {
    this.contract.methods.deleteStudent(studentAddress).send({from: signerAddress});
  }
  deleteStudentFromCourse(studentAddress) {
    this.contract.methods.deleteStudentFromCourse(studentAddress).send({from: signerAddress});
  }
  deleteTeacher(teacher) {
    this.contract.methods.deleteTeacher(teacher).send({from: signerAddress});
  }
  getAverageAttendance(courseId, studentAddress) {
    this.contract.methods.getAverageAttendance(courseId, studentAddress).send({from: signerAddress});
  }
  getCourseId(courseName) {
    this.contract.methods.getCourseId(courseName).send({from: signerAddress});
  }
  getGradeBook(courseId, studentAddress, startDate, endDate) {
    this.contract.methods.getGradeBook(courseId, studentAddress, startDate, endDate).send({from: signerAddress});
  }
  getTimeTable(courseId, studentAddress, teacherAddress) {
    this.contract.methods.getTimeTable(courseId, studentAddress, teacherAddress).send({from: signerAddress});
  }
  insertCourseInTimetable(courseId, day, numberOfLesson) {
    this.contract.methods.insertCourseInTimetable(courseId, day, numberOfLesson).send({from: signerAddress});
  }
  isAdmin(userAddress) {
    this.contract.methods.isAdmin(userAddress).send({from: signerAddress});
  }
  isSuperAdmin(userAddress) {
    this.contract.methods.isSuperAdmin(userAddress).send({from: signerAddress});
  }
  isTeacher(userAddress) {
    this.contract.methods.isTeacher(userAddress).send({from: signerAddress});
  }
  isStudent(userAddress) {
    this.contract.methods.isAdmin(userAddress).send({from: signerAddress});
  }
  isCourseUser(userAddress) {
    this.contract.methods.isCourseUser(userAddress).send({from: signerAddress});
  }
  makeCourseAvailableForGroup(courseId, groupId) {
    this.contract.methods.makeCourseAvailableForGroup(courseId, groupId).send({from: signerAddress});
  }
  makeCourseUnavailableForGroup(courseId, groupId) {
    this.contract.methods.makeCourseUnavailableForGroup(courseId, groupId).send({from: signerAddress});
  }
  markAttendance(date, courseId, studentAddress, status) {
    this.contract.methods.markAttendance(date, courseId, studentAddress, status).send({from: signerAddress});
  }
  rateAssignment(date, courseId, studentAddress, grade) {
    this.contract.methods.rateAssignment(date, courseId, studentAddress, grade).send({from: signerAddress});
  }
  requestToJoinCourse(courseId) {
    this.contract.methods.requestToJoinCourse(courseId).send({from: signerAddress});
  }
  unassignGroupFromCourseTeacher(groupId, courseId, teacherAddress) {
    this.contract.methods.unassignGroupFromCourseTeacher(groupId, courseId, teacherAddress).send({from: signerAddress});
  }
  unassignTeacherFromCourse(teacherAddress, courseId) {
    this.contract.methods.unassignTeacherFromCourse(teacherAddress, courseId).send({from: signerAddress});
  }
}
