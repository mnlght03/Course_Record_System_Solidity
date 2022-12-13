const readInput = require("./readInput");

class AdminMenu {
  options = [
    "1. Add",
    "2. Delete",
    "3. Edit Timetable",
    "4. View Timetable",
    "5. View Gradebook",
    "6. View statistics"
  ];
  addOptions = [
    "1. Add New Admin",
    "2. Add New Teacher",
    "3. Add New Student",
    "4. Add New Course",
    "5. Add New Group"
  ];
  deleteOptions = [
    "1. Delete Teacher",
    "2. Delete Student",
    "3. Delete Group",
    "4. Delete Course"
  ];
  printMain() {
    for (let option of this.options) {
      console.log(option);
    }
  }
  async processMain() {
    const key = await readInput("\t");
    switch(key) {
      case "1": this.printAdd(); return this.processAdd();
      case "2": this.printDelete(); return this.processDelete();
      case "3": return this.options[2];
      case "4": return this.options[3];
      case "5": return this.options[4];
      case "6": return this.options[5];
      default: return "";
    }
  }
  printAdd() {
    for (let option of this.addOptions) {
      console.log(option);
    }
  }
  async processAdd() {
    const key = await readInput("\t");
    switch(key) {
      case "1": return this.addOptions[0].slice(3);
      case "2": return this.addOptions[1].slice(3);
      case "3": return this.addOptions[2].slice(3);
      case "4": return this.addOptions[3].slice(3);
      case "5": return this.addOptions[4].slice(3);
      default: return "";
    }
  }
  printDelete() {
    for (let option of this.deleteOptions) {
      console.log(option);
    }
  }
  async processDelete() {
    const key = await readInput("\t");
    switch(key) {
      case "1": return this.deleteOptions[0].slice(3);
      case "2": return this.deleteOptions[1].slice(3);
      case "3": return this.deleteOptions[2].slice(3);
      case "4": return this.deleteOptions[3].slice(3);
      default: return "";
    }
  }
}

module.exports = AdminMenu;