const express = require("express")

const deleteRoute = new express.Router()

const deleteAdminController = require("../controllers/delete/deleteAdminController")
const deleteCourseController = require("../controllers/delete/deleteCourseController")
const deleteCourseFromTimetableController = require("../controllers/delete/deleteCourseFromTimetableController")
const deleteGroupController = require("../controllers/delete/deleteGroupController")
const deleteStudentController = require("../controllers/delete/deleteStudentController")
const deleteStudentFromCourseController = require("../controllers/delete/deleteStudentFromCourseController")
const deleteTeacherController = require("../controllers/delete/deleteTeacherController")

deleteRoute.post("/admin", deleteAdminController)
deleteRoute.post("/course", deleteCourseController)
deleteRoute.post("/coursefromtimetable", deleteCourseFromTimetableController)
deleteRoute.post("/group", deleteGroupController)
deleteRoute.post("/student", deleteStudentController)
deleteRoute.post("/studenttocourse", deleteStudentFromCourseController)
deleteRoute.post("/teacher", deleteTeacherController)

module.exports = deleteRoute