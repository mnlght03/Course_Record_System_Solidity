const { expect } = require("chai");
const { ethers } = require("hardhat");
const { isCallTrace } = require("hardhat/internal/hardhat-network/stack-traces/message-trace");

beforeEach(async function() {
  AdminList = await ethers.getContractFactory("AdminList");
  [admin1, admin2] = await ethers.getSigners();
  adminList = await AdminList.deploy();
  await adminList.deployed();
});

describe("AdminList", function() {
  it("addAdmin adminId test", async function() {
    await adminList.addAdmin(admin1.address);
    expect(await adminList.adminId(admin1.address)).to.equal(1);
  });
  it("addAdmin admin address test", async function() {
    await adminList.addAdmin(admin1.address);
    admin = await (await ethers.getContractFactory("Administrator")).attach(adminList.admins(0));
    expect(await admin.getAddress()).to.equal(admin1.address);
  });
  it("Admin idx should equal id - 1", async function() {
    await adminList.addAdmin(admin1.address);
    expect(await adminList.getAdminIdx(admin1.address)).to.equal(0);
  });
  it("deleteAdmin test", async function() {
    await adminList.addAdmin(admin1.address);
    await adminList.deleteAdmin(admin1.address);
    expect(await adminList.adminId(admin1.address)).to.equal(0);
  });
});