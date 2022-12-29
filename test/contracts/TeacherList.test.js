const { expect } = require("chai");
const { ethers } = require("hardhat");
const { isCallTrace } = require("hardhat/internal/hardhat-network/stack-traces/message-trace");

beforeEach(async function() {
  TeacherList = await ethers.getContractFactory("TeacherList");
  [teacher1, teacher2, student1, student2] = await ethers.getSigners();
  teacherList = await TeacherList.deploy();
  await teacherList.deployed();
});

describe("teacherList", function() {
  it("addTeacher teacherId test", async function() {
    await teacherList.addTeacher(teacher1.address);
    expect(await teacherList.teacherId(teacher1.address)).to.equal(1);
  });
  it("addTeacher correct teacher address test", async function() {
    await teacherList.addTeacher(teacher1.address);
    teacher = await (await ethers.getContractFactory("Teacher")).attach(teacherList.list(0));
    expect(await teacher.getAddress()).to.equal(teacher1.address);
  });
  it("deleteTeacher test: teacher should be deleted", async function() {
    await teacherList.addTeacher(teacher1.address);
    await teacherList.deleteTeacher(teacher1.address);
    expect(await teacherList.teacherId(teacher1.address)).to.equal(0);
  });
  it("deleteTeacher test: teacherId should be set to 0", async function() {
    await teacherList.addTeacher(teacher1.address);
    await teacherList.deleteTeacher(teacher1.address);
    expect(await teacherList.list(0)).to.equal(ethers.constants.AddressZero);
  });
  it("deleteTeacher test: non-existent teacher, transaction should be reverted", async function() {
    await expect(teacherList.deleteTeacher(teacher1.address)).to.be.revertedWith("Teacher doesn't exist");
  });
  it("assignTeacherToCourse test", async function() {
    await teacherList.addTeacher(teacher1.address);
    await teacherList.assignTeacherToCourse(teacher1.address, 1);
    teacher = await (await ethers.getContractFactory("Teacher")).attach(teacherList.list(0));
    expect(await teacher.teachesCourse(1)).to.equal(true);
  });
  it("unassignTeacherFromCourse test", async function() {
    await teacherList.addTeacher(teacher1.address);
    await teacherList.assignTeacherToCourse(teacher1.address, 1);
    await teacherList.unassignTeacherFromCourse(teacher1.address, 1);
    teacher = await (await ethers.getContractFactory("Teacher")).attach(teacherList.list(0));
    expect(await teacher.teachesCourse(1)).to.equal(false);
  });
  it("assignGroupToCourseTeacher test", async function() {
    await teacherList.addTeacher(teacher1.address);
    await teacherList.assignTeacherToCourse(teacher1.address, 1);
    await teacherList.assignGroupToCourseTeacher(teacher1.address, 21201, 1);
    teacher = await (await ethers.getContractFactory("Teacher")).attach(teacherList.list(0));
    expect(await teacher.teachesToGroup(1, 21201)).to.equal(true);
  });
  it("unassignGroupFromCourseTeacher test", async function() {
    await teacherList.addTeacher(teacher1.address);
    await teacherList.assignTeacherToCourse(teacher1.address, 1);
    await teacherList.assignGroupToCourseTeacher(teacher1.address, 21201, 1);
    await teacherList.unassignGroupFromCourseTeacher(teacher1.address, 21201, 1);
    teacher = await (await ethers.getContractFactory("Teacher")).attach(teacherList.list(0));
    expect(await teacher.teachesToGroup(1, 21201)).to.equal(false);
  });
  it("sendRequest test: teacher doesn't teach course, transaction should be reverted", async function() {
    await teacherList.addTeacher(teacher1.address);
    await expect(teacherList.sendRequest(student1.address, teacher1.address, 1)).to.be
                .revertedWith("Teacher doesn't teach this course");
  });
  it("sendRequest test: correct student address", async function() {
    await teacherList.addTeacher(teacher1.address);
    await teacherList.assignTeacherToCourse(teacher1.address, 1);
    await teacherList.sendRequest(student1.address, teacher1.address, 1)
    teacher = await (await ethers.getContractFactory("Teacher")).attach(teacherList.list(0));
    let request = await teacher.courseRequests(0);
    expect(await request.student).to.equal(student1.address);
  });
  it("sendRequest test: correct courseId ", async function() {
    await teacherList.addTeacher(teacher1.address);
    await teacherList.assignTeacherToCourse(teacher1.address, 1);
    await teacherList.sendRequest(student1.address, teacher1.address, 1)
    teacher = await (await ethers.getContractFactory("Teacher")).attach(teacherList.list(0));
    let request = await teacher.courseRequests(0);
    expect(await request.courseId).to.equal(1);
  });
  it("deleteRequest test: request doesn't exist, transaction should be reverted", async function() {
    await teacherList.addTeacher(teacher1.address);
    await teacherList.assignTeacherToCourse(teacher1.address, 1);
    await expect(teacherList.deleteRequest(teacher1.address, student1.address, 1)).to.be.revertedWith("Request doesn't exist");
  });
  it("deleteRequest test: request exists", async function() {
    await teacherList.addTeacher(teacher1.address);
    await teacherList.assignTeacherToCourse(teacher1.address, 1);
    await teacherList.assignTeacherToCourse(teacher1.address, 2);
    await teacherList.sendRequest(student1.address, teacher1.address, 1)
    await teacherList.sendRequest(student1.address, teacher1.address, 2)
    await teacherList.deleteRequest(teacher1.address, student1.address, 1)
    teacher = await (await ethers.getContractFactory("Teacher")).attach(teacherList.list(0));
    let request = await teacher.courseRequests(0);
    expect(await request.courseId).to.equal(0);
    expect(await request.student).to.equal(ethers.constants.AddressZero);
  });
  it("deleteRequest test: you can send requests after courseRequest[] was deleted", async function() {
    await teacherList.addTeacher(teacher1.address);
    await teacherList.assignTeacherToCourse(teacher1.address, 1);
    await teacherList.assignTeacherToCourse(teacher1.address, 2);
    await teacherList.sendRequest(student1.address, teacher1.address, 1)
    await teacherList.deleteRequest(teacher1.address, student1.address, 1)
    await teacherList.sendRequest(student2.address, teacher1.address, 2);
    teacher = await (await ethers.getContractFactory("Teacher")).attach(teacherList.list(0));
    let request = await teacher.courseRequests(0);
    expect(await request.courseId).to.equal(2);
    expect(await request.student).to.equal(student2.address);
  });
});