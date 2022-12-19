const express = require("express")

const teacherRoute = new express.Router()

const markAttendanceController = require("../controllers/teacher/markAttendanceController")
const rateAssignmentController = require("../controllers/teacher/rateAssignmentController")

teacherRoute.post("/markattendance", markAttendanceController)
teacherRoute.post("/rateassignment", rateAssignmentController)

module.exports = teacherRoute