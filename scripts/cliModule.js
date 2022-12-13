const Web3 = require("web3");
const { CourseSystem } = require("./CourseSystem");
require("dotenv").config()

const web3 = new Web3(process.env.WEB3_PROVIDER);

(async () => {
  if (process.argv.length != 4) {
    console.log("Usage: node cliModule.js <your_address> <your_private_key>");
    return;
  }
  const userAddress = process.argv[2].toString();
  const privateKey = process.argv[3].toString();
  const courseSystem = new CourseSystem(userAddress, privateKey);
  console.log("Welcome to the CourseSystem!");
  userRole = await courseSystem.roles(userAddress);
  console.log("Your role is: ", userRole);
  printMenu(userRole);
})();
