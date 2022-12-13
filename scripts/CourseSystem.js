const fs = require("fs");
const Web3 = require("web3");
require("dotenv").config()

const web3 = new Web3(process.env.WEB3_PROVIDER);

const abi = JSON.parse(fs.readFileSync("../compiled_contracts/CourseSystem.abi").toString());

class CourseSystem {
  contractAddress = process.env.CONTRACT_ADDRESS;
  signerAddress;
  privateKey;
  contract;

  constructor(addr, key) {
    this.signerAddress = addr;
    this.privateKey = key;
    this.contract = new web3.eth.Contract(abi, this.contractAddress, {
      from: this.signerAddress,
      gasPrice: "30000000000000"
    });
  }

  acceptRequest(studentAddress, courseId) {
    return this.contract.methods.acceptRequest(studentAddress, courseId).send({from: this.signerAddress});
  }
  addAdmin(newAdmin) {
    return this.contract.methods.addAdmin(newAdmin).send({from: this.signerAddress});
  }
  addCourse(courseName) {
    return this.contract.methods.addCourse(courseName).send({from: this.signerAddress});
  }
  addGroup(groupId) {
    return this.contract.methods.addGroup(groupId).send({from: this.signerAddress});
  }
  addStudent(newStudent, groupId) {
    return this.contract.methods.addStudent(newStudent, groupId).send({from: this.signerAddress});
  }
  addStudentToCourse(studentAddress, courseId) {
    return this.contract.methods.addStudentToCourse(studentAddress, courseId).send({from: this.signerAddress});
  }
  assignGroupToCourseTeacher(groupId, courseId, teacherAddress) {
    return this.contract.methods.assignGroupToCourseTeacher(groupId, courseId, teacherAddress).send({from: this.signerAddress});
  }
  assignTeacherToCourse(teacherAddress, courseId) {
    return this.contract.methods.assignTeacherToCourse(teacherAddress, courseId).send({from: this.signerAddress});
  }
  changeCourseInTimetable(day, numberOfLesson, newCourse) {
    return this.contract.methods.changeCourseInTimetable(day, numberOfLesson, newCourse).send({from: this.signerAddress});
  }
  changeStudentGroup(studentAddress, newGroup) {
    return this.contract.methods.changeStudentGroup(studentAddress, newGroup).send({from: this.signerAddress});
  }
  declineRequest(studentAddress, courseId) {
    return this.contract.methods.declineRequest(studentAddress, courseId).send({from: this.signerAddress});
  }
  deleteAdmin(admin) {
    return this.contract.methods.deleteAdmin(admin).send({from: this.signerAddress});
  }
  deleteCourse(courseId) {
    return this.contract.methods.deleteCourse(courseId).send({from: this.signerAddress});
  }
  deleteCourseFromTimetable(day, numberOfLesson) {
    return this.contract.methods.deleteCourseFromTimetable(day, numberOfLesson).send({from: this.signerAddress});
  }
  deleteGroup(groupId) {
    return this.contract.methods.deleteGroup(groupId).send({from: this.signerAddress});
  }
  deleteStudent(studentAddress) {
    return this.contract.methods.deleteStudent(studentAddress).send({from: this.signerAddress});
  }
  deleteStudentFromCourse(studentAddress) {
    return this.contract.methods.deleteStudentFromCourse(studentAddress).send({from: this.signerAddress});
  }
  deleteTeacher(teacher) {
    return this.contract.methods.deleteTeacher(teacher).send({from: this.signerAddress});
  }
  getAverageAttendance(courseId, studentAddress) {
    return this.contract.methods.getAverageAttendance(courseId, studentAddress).call({from: this.signerAddress});
  }
  getCourseId(courseName) {
    return this.contract.methods.getCourseId(courseName).call({from: this.signerAddress});
  }
  getGradeBook(courseId, studentAddress, startDate, endDate) {
    return this.contract.methods.getGradeBook(courseId, studentAddress, startDate, endDate).call({from: this.signerAddress});
  }
  getTimeTable(courseId, studentAddress, teacherAddress) {
    return this.contract.methods.getTimeTable(courseId, studentAddress, teacherAddress).call({from: this.signerAddress});
  }
  insertCourseInTimetable(courseId, day, numberOfLesson) {
    return this.contract.methods.insertCourseInTimetable(courseId, day, numberOfLesson).send({from: this.signerAddress});
  }
  isAdmin(userAddress) {
    return this.contract.methods.isAdmin(userAddress).send({from: this.signerAddress});
  }
  isSuperAdmin(userAddress) {
    return this.contract.methods.isSuperAdmin(userAddress).send({from: this.signerAddress});
  }
  isTeacher(userAddress) {
    return this.contract.methods.isTeacher(userAddress).send({from: this.signerAddress});
  }
  isStudent(userAddress) {
    return this.contract.methods.isAdmin(userAddress).send({from: this.signerAddress});
  }
  isCourseUser(userAddress) {
    return this.contract.methods.isCourseUser(userAddress).send({from: this.signerAddress});
  }
  makeCourseAvailableForGroup(courseId, groupId) {
    return this.contract.methods.makeCourseAvailableForGroup(courseId, groupId).send({from: this.signerAddress});
  }
  makeCourseUnavailableForGroup(courseId, groupId) {
    return this.contract.methods.makeCourseUnavailableForGroup(courseId, groupId).send({from: this.signerAddress});
  }
  markAttendance(date, courseId, studentAddress, status) {
    return this.contract.methods.markAttendance(date, courseId, studentAddress, status).send({from: this.signerAddress});
  }
  rateAssignment(date, courseId, studentAddress, grade) {
    return this.contract.methods.rateAssignment(date, courseId, studentAddress, grade).send({from: this.signerAddress});
  }
  requestToJoinCourse(courseId) {
    return this.contract.methods.requestToJoinCourse(courseId).send({from: this.signerAddress});
  }
  roles(userAddress) {
    return this.contract.methods.roles(userAddress).call({from: this.signerAddress}).then(
      (res) => {
        switch(res) {
          case "0": return "NONE";
          case "1": return "SUPERADMIN"
          case "2": return "ADMIN";
          case "3": return "TEACHER";
          case "4": return "STUDENT";
          default: return res;
        }
      });
  }
  unassignGroupFromCourseTeacher(groupId, courseId, teacherAddress) {
    return this.contract.methods.unassignGroupFromCourseTeacher(groupId, courseId, teacherAddress).send({from: this.signerAddress});
  }
  unassignTeacherFromCourse(teacherAddress, courseId) {
    return this.contract.methods.unassignTeacherFromCourse(teacherAddress, courseId).send({from: this.signerAddress});
  }
}

module.exports = { CourseSystem }
