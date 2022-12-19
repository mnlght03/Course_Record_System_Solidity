const readInput = require("./readInput");

class TeacherMenu {
  options = [
    "1. Pending Requests",
    "2. Mark Attendance",
    "3. Rate Assignment",
    "4. View Timetable",
    "5. View Gradebook",
    "6. View statistics"
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
      case "6": return this.options[5];
      default: return "";
    }
  }
}

module.exports = TeacherMenu;