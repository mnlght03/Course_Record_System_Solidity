const readInput = require("./readInput");

class StudentMenu {
  options = [
    "1. Pending Requests",
    "2. Send New Request",
    "3. View Timetable",
    "4. View Gradebook",
    "5. View statistics"
  ];
  printMain() {
    for (let option of this.options) {
      console.log(option);
    }
  }
  async processMain() {
    const key = await readInput("\t");
    switch(key) {
      case "1": return this.options[0];
      case "2": return this.options[1];
      case "3": return this.options[2];
      case "4": return this.options[3];
      case "5": return this.options[4];
      default: return "";
    }
  }
}

module.exports = StudentMenu;