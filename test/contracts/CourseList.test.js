const { expect } = require("chai");
const { ethers } = require("hardhat");
const { isCallTrace } = require("hardhat/internal/hardhat-network/stack-traces/message-trace");

beforeEach(async function() {
  CourseList = await ethers.getContractFactory("CourseList");
  [owner, teacher] = await ethers.getSigners();
  courseList = await CourseList.deploy();
  await courseList.deployed();
});

describe("CourseList", function() {
  it("addCourse test: totalCourses should increase by one", async function() {
    await courseList.addCourse("new course");
    expect(await courseList.totalCourses()).to.equal(1);
  });
  it("addCourse test: list length should increase by one", async function() {
    await courseList.addCourse("new course");
    expect(await courseList.getListLength()).to.equal(1);
  });
  it("addCourse test: course id should equal to list.length test", async function() {
    await courseList.addCourse("new course");
    expect(await courseList.courseId("new course")).to.equal(1);
  });
  it("courseId test: non-existent course id should equal to 0", async function() {
    await courseList.addCourse("new course");
    expect(await courseList.courseId("some other course")).to.equal(0);
  });
  it("courseExistst test: course exists", async function() {
    await courseList.addCourse("new course");
    expect(await courseList.courseExists(await courseList.courseId("new course"))).to.equal(true);
  });
  it("courseExistst test: course doesn't exist", async function() {
    await courseList.addCourse("new course");
    expect(await courseList.courseExists(0)).to.equal(false);
    expect(await courseList.courseExists(2)).to.equal(false);
  });
  it("deleteCourse test: existent course should be deleted", async function() {
    await courseList.addCourse("new course");
    await courseList.deleteCourse(1);
    expect(await courseList.courseExists(1)).to.equal(false);
  });
  it("deleteCourse test: non-existent course, transaction should be reverted", async function() {
    await courseList.addCourse("new course");
    await expect(courseList.deleteCourse(2)).to.be.revertedWith("deleteCourse: Course doesn't exist");
  });
  it("makeCourseAvailableForGroup test", async function() {
    await courseList.addCourse("new course");
    await courseList.makeCourseAvailableForGroup(1, 21201);
    course = await (await ethers.getContractFactory("Course"))
            .attach(courseList.getCourse(courseList.courseId("new course")));
    expect(await course.availableForGroup(21201)).to.equal(true);
  });
  it("makeCourseUnavailableForGroup test: existent course", async function() {
    await courseList.addCourse("new course");
    await courseList.makeCourseAvailableForGroup(1, 21201);
    await courseList.makeCourseUnavailableForGroup(1, 21201);
    course = await (await ethers.getContractFactory("Course"))
            .attach(courseList.getCourse(courseList.courseId("new course")));
    expect(await course.availableForGroup(21201)).to.equal(false);
  });
  it("makeCourseUnavailableForGroup test: non-existent course, transaction should be reverted", async function() {
    await expect(courseList.makeCourseUnavailableForGroup(0, 21201)).to.be
          .revertedWith("makeCourseUnavailableForGroup: Course doesn't exist");
  });
  it("addTeacher test: correct teacher address saved", async function() {
    await courseList.addCourse("new course");
    await courseList.addTeacher(1, teacher.address);
    course = await (await ethers.getContractFactory("Course"))
            .attach(courseList.getCourse(courseList.courseId("new course")));
    expect(await course.teacherAddresses(0)).to.equal(teacher.address);
  });
  it("addTeacher test: totalTeachers should increase by one", async function() {
    await courseList.addCourse("new course");
    await courseList.addTeacher(1, teacher.address);
    course = await (await ethers.getContractFactory("Course"))
            .attach(courseList.getCourse(courseList.courseId("new course")));
    expect(await course.totalTeachers()).to.equal(1);
  });
  it("deleteTeacher test: teacher address should be deleted", async function() {
    await courseList.addCourse("new course");
    await courseList.addTeacher(1, teacher.address);
    await courseList.deleteTeacher(1, teacher.address);
    course = await (await ethers.getContractFactory("Course"))
            .attach(courseList.getCourse(courseList.courseId("new course")));
    expect(await course.teacherAddresses(0)).to.equal(ethers.constants.AddressZero);
  });
  it("deleteTeacher test: totalTeachers should decrease by one", async function() {
    await courseList.addCourse("new course");
    await courseList.addTeacher(1, teacher.address);
    await courseList.deleteTeacher(1, teacher.address);
    course = await (await ethers.getContractFactory("Course"))
            .attach(courseList.getCourse(courseList.courseId("new course")));
    expect(await course.totalTeachers()).to.equal(0);
  });
});