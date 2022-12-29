const { expect } = require("chai");
const { ethers } = require("hardhat");
const { isCallTrace } = require("hardhat/internal/hardhat-network/stack-traces/message-trace");

beforeEach(async function() {
  TimeTable = await ethers.getContractFactory("TimeTable");
  [teacher1, teacher2, student1, student2] = await ethers.getSigners();
  timeTable = await TimeTable.deploy();
  await timeTable.deployed();
});

describe("TimeTable", () => {
  it("insertCourse test", async () => {
    await timeTable.insertCourse(1, 1, 2);
    expect(await timeTable.table(1, 2)).to.equal(1);
  });
  it("deleteCourse test", async () => {
    await timeTable.insertCourse(1, 1, 2);
    await timeTable.deleteCourse(1, 2);
    expect(await timeTable.table(1, 2)).to.equal(0);
  });
  it("getCourseId test", async () => {
    await timeTable.insertCourse(1, 1, 2);
    expect(await timeTable.getCourseId(1, 2)).to.equal(1);
  });
  it("getWholeTable test", async () => {
    await timeTable.insertCourse(1, 1, 2);
    await timeTable.insertCourse(1, 1, 3);
    await timeTable.insertCourse(2, 1, 1);
    await timeTable.insertCourse(3, 2, 2);
    await timeTable.insertCourse(3, 3, 3);
    await timeTable.insertCourse(4, 4, 4);
    await timeTable.insertCourse(5, 5, 5);
    await timeTable.insertCourse(5, 6, 7);
    expect(await timeTable.getWholeTable())
           .to.equal([[0, 0, 0, 0, 0, 0, 0, 0, 0],
                      [0, 2, 1, 1, 0, 0, 0, 0, 0],
                      [0, 0, 3, 0, 0, 0, 0, 0, 0],
                      [0, 0, 0, 3, 0, 0, 0, 0, 0],
                      [0, 0, 0, 0, 4, 0, 0, 0, 0],
                      [0, 0, 0, 0, 0, 5, 0, 0, 0],
                      [0, 0, 0, 0, 0, 0, 0, 5, 0]]);
  });
  it("getTable test", async () => {
    await timeTable.insertCourse(1, 1, 2);
    await timeTable.insertCourse(1, 1, 3);
    await timeTable.insertCourse(2, 1, 1);
    await timeTable.insertCourse(3, 2, 2);
    await timeTable.insertCourse(3, 3, 3);
    await timeTable.insertCourse(4, 4, 4);
    await timeTable.insertCourse(5, 5, 5);
    await timeTable.insertCourse(5, 6, 7);
    expect(await timeTable.getTable([3, 5]))
           .to.equal([[0, 0, 0, 0, 0, 0, 0, 0, 0],
                      [0, 0, 0, 0, 0, 0, 0, 0, 0],
                      [0, 0, 3, 0, 0, 0, 0, 0, 0],
                      [0, 0, 0, 3, 0, 0, 0, 0, 0],
                      [0, 0, 0, 0, 0, 0, 0, 0, 0],
                      [0, 0, 0, 0, 0, 5, 0, 0, 0],
                      [0, 0, 0, 0, 0, 0, 0, 5, 0]]);
  });
});