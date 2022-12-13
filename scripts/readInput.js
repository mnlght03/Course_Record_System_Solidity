const readline = require("readline");

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});
rl.pause();

function readInput(question, cb = () => void 0) {
  return new Promise(resolve => {
    rl.question(question, (...args) => {
      rl.pause();
      resolve(...args);
      cb(...args);
    });
  });
}

module.exports = readInput;