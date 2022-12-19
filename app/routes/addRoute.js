const express = require("express")

const addRoute = new express.Router()

const addAdminController = require("../controllers/add/addAdminController")
const addCourseController = require("../controllers/add/addCourseController")
const addGroupController = require("../controllers/add/addGroupController")
const addStudentController = require("../controllers/add/addStudentController")
const addStudentToCourseController = require("../controllers/add/addStudentToCourseController")
const addTeacherController = require("../controllers/add/addTeacherController")

addRoute.post("/admin", addAdminController)
addRoute.post("/course", addCourseController)
addRoute.post("/group", addGroupController)
addRoute.post("/student", addStudentController)
addRoute.post("/studenttocourse", addStudentToCourseController)
addRoute.post("/teacher", addTeacherController)

module.exports = addRoute