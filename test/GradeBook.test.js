const { expect } = require("chai");
const { ethers } = require("hardhat");
const { isCallTrace } = require("hardhat/internal/hardhat-network/stack-traces/message-trace");

beforeEach(async function() {
  GradeBook = await ethers.getContractFactory("GradeBook");
  [owner, teacher1, student1, student2] = await ethers.getSigners();
  gradeBook = await GradeBook.deploy();
  await gradeBook.deployed();
});

describe("GradeBook", () => {
  it("setGrade test: saved grade is correct", async () => {
    await gradeBook.setGrade(29112022, 1, student1.address, 5);
    let entry = await gradeBook.entries(29112022, 1, student1.address);
    expect(entry.grade).to.equal(5);
  });
  it("setGrade test: totalScore is updated correctly when grade changed", async () => {
    await gradeBook.setGrade(29112022, 1, student1.address, 5);
    await gradeBook.setGrade(29112022, 1, student1.address, 4);
    expect(await gradeBook.totalScore(student1.address, 1)).to.equal(4);
  });
  it("setGrade test: totalScore is updated correctly when new grade marked", async () => {
    await gradeBook.setGrade(29112022, 1, student1.address, 5);
    await gradeBook.setGrade(28112022, 1, student1.address, 4);
    expect(await gradeBook.totalScore(student1.address, 1)).to.equal(9);
  });
  it("setGrade test: totalMarks is updated correctly when grade changed", async () => {
    await gradeBook.setGrade(29112022, 1, student1.address, 5);
    await gradeBook.setGrade(29112022, 1, student1.address, 4);
    expect(await gradeBook.totalMarks(student1.address, 1)).to.equal(1);
  });
  it("setGrade test: totalMarks is updated correctly when new grade marked", async () => {
    await gradeBook.setGrade(29112022, 1, student1.address, 5);
    await gradeBook.setGrade(28112022, 1, student1.address, 4);
    expect(await gradeBook.totalMarks(student1.address, 1)).to.equal(2);
  });
  it("markAttendance test: attendence marked correctly", async () => {
    await gradeBook.markAttendance(29112022, 1, student1.address, true);
    let entry = await gradeBook.entries(29112022, 1, student1.address);
    expect(entry.attended).to.equal(true);
  });
  it("markAttendance test: totalAttended counter is increased correctly", async () => {
    await gradeBook.markAttendance(29112022, 1, student1.address, true);
    expect(await gradeBook.totalAttended(student1.address, 1)).to.equal(1);
  });
  it("getAverageScore test 1", async () => {
    await gradeBook.setGrade(29112022, 1, student1.address, 5);
    await gradeBook.setGrade(28112022, 1, student1.address, 5);
    await gradeBook.setGrade(27112022, 1, student1.address, 5);
    expect(await gradeBook.getAverageScore(student1.address, 1)).to.equal(5);
  });
  it("getAverageScore test 2", async () => {
    await gradeBook.setGrade(29112022, 1, student1.address, 5);
    await gradeBook.setGrade(28112022, 1, student1.address, 4);
    await gradeBook.setGrade(27112022, 1, student1.address, 3);
    expect(await gradeBook.getAverageScore(student1.address, 1)).to.equal(4);
  });
  it("getAverageScore test 3", async () => {
    await gradeBook.setGrade(29112022, 1, student1.address, 5);
    await gradeBook.setGrade(28112022, 1, student1.address, 2);
    await gradeBook.setGrade(27112022, 1, student1.address, 3);
    expect(await gradeBook.getAverageScore(student1.address, 1)).to.equal(3);
  });
  it("getAverageAttendance test 1", async () => {
    await gradeBook.markAttendance(29112022, 1, student1.address, true);
    await gradeBook.markAttendance(28112022, 1, student1.address, true);
    await gradeBook.increaseTotalLessons(student1.address, 1);
    await gradeBook.increaseTotalLessons(student1.address, 1);
    await gradeBook.increaseTotalLessons(student1.address, 1);
    await gradeBook.increaseTotalLessons(student1.address, 1);
    expect(await gradeBook.getAverageAttendance(student1.address, 1)).to.equal(50);
  });
  it("getAverageAttendance test 2", async () => {
    await gradeBook.markAttendance(29112022, 1, student1.address, true);
    await gradeBook.markAttendance(28112022, 1, student1.address, true);
    await gradeBook.increaseTotalLessons(student1.address, 1);
    await gradeBook.increaseTotalLessons(student1.address, 1);
    expect(await gradeBook.getAverageAttendance(student1.address, 1)).to.equal(100);
  });
  it("getAverageAttendance test 3", async () => {
    await gradeBook.markAttendance(29112022, 1, student1.address, true);
    await gradeBook.increaseTotalLessons(student1.address, 1);
    await gradeBook.increaseTotalLessons(student1.address, 1);
    await gradeBook.increaseTotalLessons(student1.address, 1);
    expect(await gradeBook.getAverageAttendance(student1.address, 1)).to.equal(33);
  });
});