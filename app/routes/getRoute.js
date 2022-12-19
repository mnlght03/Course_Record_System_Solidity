const express = require("express")

const getRoute = new express.Router()

const getAverageAttendanceController = require("../controllers/get/getAverageAttendanceController")
const getAverageScoreController = require("../controllers/get/getAverageScoreController")
const getCourseIdController = require("../controllers/get/getCourseIdController")
const getGradeBookController = require("../controllers/get/getGradeBookController")
const getTimetableController = require("../controllers/get/getTimetableController")

getRoute.get("/averageattendance", getAverageAttendanceController)
getRoute.get("/averagescore", getAverageScoreController)
getRoute.get("/courseid", getCourseIdController)
getRoute.get("/gradebook", getGradeBookController)
getRoute.get("/timetable", getTimetableController)


module.exports = getRoute