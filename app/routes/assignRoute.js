const express = require("express")

const assignRoute = new express.Router()

const assignTeacherToCourseController = require("../controllers/assign/assignTeacherToCourseController")
const assignGroupToTeacherController = require("../controllers/assign/assignGroupToTeacherController")

assignRoute.post("/teachertocourse", assignTeacherToCourseController)
assignRoute.post("/grouptoteacher", assignGroupToTeacherController)

module.exports = assignRoute