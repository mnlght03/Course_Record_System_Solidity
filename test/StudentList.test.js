const { expect } = require("chai");
const { ethers } = require("hardhat");
const { isCallTrace } = require("hardhat/internal/hardhat-network/stack-traces/message-trace");

beforeEach(async function() {
  StudentList = await ethers.getContractFactory("StudentList");
  [student1, student2] = await ethers.getSigners();
  studentList = await StudentList.deploy();
  await studentList.deployed();
});

describe("StudentList", function() {
  it("addStudent studentId test", async function() {
    await studentList.addStudent(student1.address, 21201);
    expect(await studentList.studentId(student1.address)).to.equal(1);
  });
  it("addStudent correct student address test", async function() {
    await studentList.addStudent(student1.address, 21201);
    student = await (await ethers.getContractFactory("Student")).attach(studentList.list(0));
    expect(await student.getAddress()).to.equal(student1.address);
  });
  it("addStudent correct student group test", async function() {
    await studentList.addStudent(student1.address, 21201);
    student = await (await ethers.getContractFactory("Student")).attach(studentList.list(0));
    expect(await student.groupId()).to.equal(21201);
  });
  it("Student idx should equal id - 1", async function() {
    await studentList.addStudent(student1.address, 21201);
    expect(await studentList.getStudentIdx(student1.address)).to.equal(0);
  });
  it("deleteStudent test: student be deleted", async function() {
    await studentList.addStudent(student1.address, 21201);
    await studentList.deleteStudent(student1.address);
    expect(await studentList.studentId(student1.address)).to.equal(0);
  });
  it("deleteStudent test: studentId should be set to 0", async function() {
    await studentList.addStudent(student1.address, 21201);
    await studentList.deleteStudent(student1.address);
    expect(await studentList.list(0)).to.equal(ethers.constants.AddressZero);
  });
  it("deleteSudent test: non-existent student, transaction should be reverted", async function() {
    await expect(studentList.deleteStudent(student1.address)).to.be.revertedWith("Student doesn't exist");
  });
  it("changeStudentGroup test", async function() {
    await studentList.addStudent(student1.address, 21201);
    await studentList.changeStudentGroup(student1.address, 21202);
    student = await (await ethers.getContractFactory("Student")).attach(studentList.list(0));
    expect(await student.groupId()).to.equal(21202);
  });
  it("addStudentToCourse test", async function() {
    await studentList.addStudent(student1.address, 21201);
    await studentList.addStudentToCourse(student1.address, 1);
    student = await (await ethers.getContractFactory("Student")).attach(studentList.list(0));
    expect(await student.studiesCourse(1)).to.equal(true);
  });
  it("deleteStudentFromCourse test", async function() {
    await studentList.addStudent(student1.address, 21201);
    await studentList.addStudentToCourse(student1.address, 1);
    await studentList.deleteStudentFromCourse(student1.address, 1);
    student = await (await ethers.getContractFactory("Student")).attach(studentList.list(0));
    expect(await student.studiesCourse(1)).to.equal(false);
  });
});