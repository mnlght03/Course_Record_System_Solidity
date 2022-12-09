const { expect } = require("chai");
const { ethers } = require("hardhat");
const { isCallTrace } = require("hardhat/internal/hardhat-network/stack-traces/message-trace");

beforeEach(async function() {
  CourseSystem = await ethers.getContractFactory("CourseSystem");
  [owner, admin1, admin2, student1, student2, teacher1, teacher2] = await ethers.getSigners();
  courseSystem = await CourseSystem.deploy();
  await courseSystem.deployed();
});

describe("CourseSystem", () => {
  it("constructor should set owner correctly", async () => {
    expect(await courseSystem.roles(owner.address)).to.equal(1);
    adminList = (await ethers.getContractFactory("AdminList")).attach(courseSystem.adminList());
    admin = (await ethers.getContractFactory("Administrator")).attach(adminList.admins(0));
    expect(await admin.getId()).to.equal(1);
    expect(await admin.getAddress()).to.equal(owner.address);
  });
  it("addAdmin must emit event", async () => {
    expect(await courseSystem.addAdmin(admin1.address)).to.emit(courseSystem, "NewAdmin")
            .withArgs(owner.address, admin1.address);
  });
  it("addAdmin role set correctly", async () => {
    await courseSystem.addAdmin(admin1.address);
    expect(await courseSystem.roles(admin1.address)).to.equal(2);
  });
  it("addAdmin adminId set correctly", async () => {
    await courseSystem.addAdmin(admin1.address);
    adminList = (await ethers.getContractFactory("AdminList")).attach(courseSystem.adminList());
    admin = (await ethers.getContractFactory("Administrator")).attach(adminList.admins(1));
    expect(await admin.getId()).to.equal(2);
  });
  it("addAdmin admin address set correctly", async () => {
    await courseSystem.addAdmin(admin1.address);
    adminList = (await ethers.getContractFactory("AdminList")).attach(courseSystem.adminList());
    admin = (await ethers.getContractFactory("Administrator")).attach(adminList.admins(1));
    expect(await admin.getAddress()).to.equal(admin1.address);
  });
  it("addAdmin test: admin already exists, transaction should be reverted", async () => {
    await expect(courseSystem.addAdmin(owner.address)).to.be.revertedWith("Admin already exists");
  });
  it("deleteAdmin test: admin doesn't exist, transaction should be reverted", async () => {
    await expect(courseSystem.deleteAdmin(student1.address)).to.be.revertedWith("Address is not an admin");
  });
  it("deleteAdmin must emit event", async () => {
    await courseSystem.addAdmin(admin1.address);
    expect(await courseSystem.deleteAdmin(admin1.address)).to.emit(courseSystem, "AdminDeleted")
            .withArgs(owner.address, admin1.address);
    expect(await courseSystem.roles(admin1.address)).to.equal(0);
  });
  it("deleteAdmin test: role must be set to NONE", async () => {
    await courseSystem.addAdmin(admin1.address);
    await courseSystem.deleteAdmin(admin1.address);
    expect(await courseSystem.roles(admin1.address)).to.equal(0);
  });
  it("addGroup must emit event", async () => {
    expect(await courseSystem.addGroup(21201)).to.emit(courseSystem, "NewGroup")
            .withArgs(owner.address, 21201);
  });
  it("addGroup test: group exists, transaction should be reverted", async () => {
    await courseSystem.addGroup(21201);
    await expect(courseSystem.addGroup(21201)).to.be.revertedWith("addGroup: Group already exists");
  });
  it("deleteGroup must emit event", async () => {
    await courseSystem.addGroup(21201);
    expect(await courseSystem.deleteGroup(21201)).to.emit(courseSystem, "GroupDeleted")
            .withArgs(owner.address, 21201);
  });
  it("deleteGroup test: group doesn't exist, transaction should be reverted", async () => {
    await expect(courseSystem.deleteGroup(21201)).to.be.revertedWith("deleteGroup: Group doesn't exist");
  });
  it("addTeacher must emit event", async () => {
    expect(await courseSystem.addTeacher(teacher1.address)).to.emit(courseSystem, "NewTeacher")
            .withArgs(owner.address, teacher1.address);
  });
  it("addTeacher test: teacher already exists, transaction should be reverted", async () => {
    await courseSystem.addTeacher(teacher1.address);
    await expect(courseSystem.addTeacher(teacher1.address)).to.be.revertedWith("Teacher already exists");
  });
  it("deleteTeacher must emit event", async () => {
    await courseSystem.addTeacher(teacher1.address);
    expect(await courseSystem.deleteTeacher(teacher1.address)).to.emit(courseSystem, "TeacherDeleted")
            .withArgs(owner.address, teacher1.address);
  });
  it("deleteTeacher test: teacher doesn't exist, transaction should be reverted", async () => {
    await expect(courseSystem.deleteTeacher(teacher1.address)).to.be.revertedWith("Address is not a teacher");
  });
});