const fs = require("fs");
const Web3 = require("web3");
require("dotenv").config();

const web3 = new Web3(process.env.WEB3_PROVIDER);

const abi = JSON.parse(fs.readFileSync("./compiled_contracts/CourseSystem.abi").toString());

async function send(method, contractAddress, signerAddress, privateKey) {
  const gas = await method.estimateGas({from: signerAddress});
  const txOptions = {
    from: signerAddress,
    to: contractAddress,
    gas: gas,
    data: method.encodeABI()
  }
  const signedTx = await web3.eth.accounts.signTransaction(txOptions, privateKey);

  const result = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);

  return result;
}

class CourseSystem {
  contractAddress = process.env.CONTRACT_ADDRESS;
  signerAddress;
  privateKey;
  contract;

  constructor(addr, key) {
    this.signerAddress = addr;
    this.privateKey = key;
    this.contract = new web3.eth.Contract(abi, this.contractAddress, {
      from: this.signerAddress
    });
  }

  acceptRequest(studentAddress, courseId) {
    return send(this.contract.methods.acceptRequest(studentAddress, courseId),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  addAdmin(newAdmin) {
    return send(this.contract.methods.addAdmin(newAdmin),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  addCourse(courseName) {
    return send(this.contract.methods.addCourse(courseName),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  addGroup(groupId) {
    return send(this.contract.methods.addGroup(groupId),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  addStudent(newStudent, groupId) {
    return send(this.contract.methods.addStudent(newStudent, groupId),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  addStudentToCourse(studentAddress, courseId) {
    return send(this.contract.methods.addStudentToCourse(studentAddress, courseId),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  addTeacher(newTeacher) {
    return send(this.contract.methods.addTeacher(newTeacher),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  assignGroupToCourseTeacher(groupId, courseId, teacherAddress) {
    return send(this.contract.methods.assignGroupToCourseTeacher(groupId, courseId, teacherAddress),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  assignTeacherToCourse(teacherAddress, courseId) {
    return send(this.contract.methods.assignTeacherToCourse(teacherAddress, courseId),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  changeCourseInTimetable(day, numberOfLesson, newCourse) {
    return send(this.contract.methods.changeCourseInTimetable(day, numberOfLesson, newCourse),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  changeStudentGroup(studentAddress, newGroup) {
    return send(this.contract.methods.changeStudentGroup(studentAddress, newGroup),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  declineRequest(studentAddress, courseId) {
    return send(this.contract.methods.declineRequest(studentAddress, courseId),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  deleteAdmin(admin) {
    return send(this.contract.methods.deleteAdmin(admin),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  deleteCourse(courseId) {
    return send(this.contract.methods.deleteCourse(courseId),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  deleteCourseFromTimetable(day, numberOfLesson) {
    return send(this.contract.methods.deleteCourseFromTimetable(day, numberOfLesson),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  deleteGroup(groupId) {
    return send(this.contract.methods.deleteGroup(groupId),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  deleteStudent(studentAddress) {
    return send(this.contract.methods.deleteStudent(studentAddress),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  deleteStudentFromCourse(studentAddress, courseId) {
    return send(this.contract.methods.deleteStudentFromCourse(studentAddress, courseId),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  deleteTeacher(teacher) {
    return send(this.contract.methods.deleteTeacher(teacher),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  getAverageAttendance(courseId, studentAddress) {
    return this.contract.methods.getAverageAttendance(courseId, studentAddress).call({from: this.signerAddress});
  }
  getAverageScore(courseId, studentAddress) {
    return this.contract.methods.getAverageScore(courseId, studentAddress).call({from: this.signerAddress});
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
    return send(this.contract.methods.insertCourseInTimetable(courseId, day, numberOfLesson),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  isAdmin(userAddress) {
    return this.contract.methods.isAdmin(userAddress).call({from: this.signerAddress});
  }
  isSuperAdmin(userAddress) {
    return this.contract.methods.isSuperAdmin(userAddress).call({from: this.signerAddress});
  }
  isTeacher(userAddress) {
    return this.contract.methods.isTeacher(userAddress).call({from: this.signerAddress});
  }
  isStudent(userAddress) {
    return this.contract.methods.isAdmin(userAddress).call({from: this.signerAddress});
  }
  isCourseUser(userAddress) {
    return this.contract.methods.isCourseUser(userAddress).call({from: this.signerAddress});
  }
  makeCourseAvailableForGroup(courseId, groupId) {
    return send(this.contract.methods.makeCourseAvailableForGroup(courseId, groupId),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  makeCourseUnavailableForGroup(courseId, groupId) {
    return send(this.contract.methods.makeCourseUnavailableForGroup(courseId, groupId),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  markAttendance(date, courseId, studentAddress, status) {
    return send(this.contract.methods.markAttendance(date, courseId, studentAddress, status),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  rateAssignment(date, courseId, studentAddress, grade) {
    return send(this.contract.methods.rateAssignment(date, courseId, studentAddress, grade),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  requestToJoinCourse(courseId) {
    return send(this.contract.methods.requestToJoinCourse(courseId),
                this.contractAddress, this.signerAddress,
                this.privateKey);
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
    return send(this.contract.methods.assignGroupFromCourseTeacher(groupId, courseId, teacherAddress),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
  unassignTeacherFromCourse(teacherAddress, courseId) {
    return send(this.contract.methods.unassignTeacherFromCourse(teacherAddress, courseId),
                this.contractAddress, this.signerAddress,
                this.privateKey);
  }
}

module.exports = CourseSystem
