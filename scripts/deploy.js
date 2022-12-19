const hre = require("hardhat");

async function main() {
  const CourseSystem = await hre.ethers.getContractFactory("CourseSystem");
  const courseSystem = await CourseSystem.deploy();

  await courseSystem.deployed();

  console.log(
    `CourseSystem deployed with address ${courseSystem.address}`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

