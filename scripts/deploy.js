// web3.eth.defaultAccount
// web3.eth.defaultBlock (default value == "latest")
const fs = require("fs");
const Web3 = require("web3");
require("dotenv").config()

const web3 = new Web3(process.env.WEB3_PROVIDER);

if (process.argv.length != 4)
  console.log("usage: node deploy.js <signerAddress> <privateKey>");

const signerAddress = process.argv[2].toString();
const privateKey = process.argv[3].toString();

web3.eth.defaultAccount = signerAddress;

const bytecode = fs.readFileSync("../compiled_contracts/CourseSystem.bin").toString();
const abi = JSON.parse(fs.readFileSync("../compiled_contracts/CourseSystem.abi").toString());


const courseSystem = new web3.eth.Contract(abi);
courseSystem.defaultAccount = signerAddress;
courseSystem.deploy({ data: bytecode }).send({
  from: signerAddress,
  gas: 15000000,
  gasPrice: "30000000000000"
}).then((contract) => {
  console.log("contract deployed with address: " + contract.options.address);
  courseSystem.options.address = contract.options.address;
});
