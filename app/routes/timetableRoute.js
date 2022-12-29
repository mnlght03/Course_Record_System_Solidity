const express = require("express")

const timetableRoute = new express.Router()

const insertCourseController = require("../controllers/timetable/insertCourseController")
const changeCourseController = require("../controllers/timetable/changeCourseController")

timetableRoute.post("/insertcourse", insertCourseController)
timetableRoute.post("/changecourse", changeCourseController)

module.exports = timetableRoute