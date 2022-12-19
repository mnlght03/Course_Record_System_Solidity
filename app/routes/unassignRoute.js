const express = require("express")

const unassignRoute = new express.Router()

const unassignTeacherFromCourseController = require("../controllers/unassign/unassignTeacherFromCourseController")
const unassignGroupFromTeacherController = require("../controllers/unassign/unassignGroupFromTeacherController")

unassignRoute.post("/teacherfromcourse", unassignTeacherFromCourseController)
unassignRoute.post("/groupfromteacher", unassignGroupFromTeacherController)

module.exports = unassignRoute