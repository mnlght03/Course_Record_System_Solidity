// web3.eth.defaultAccount
// web3.eth.defaultBlock (default value == "latest")
const fs = require("fs");
const Web3 = require("Web3");

const web3 = new Web3("http://127.0.0.1:8545");

const signerAddress = "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199";
const privateKey = "0xdf57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e";

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
