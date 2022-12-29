const express = require("express")

const courseRoute = new express.Router()

const makeCourseAvailableController = require("../controllers/course/makeCourseAvailableController")
const makeCourseUnavailableController = require("../controllers/course/makeCourseUnavailableController")

courseRoute.post("/makeavailable", makeCourseAvailableController)
courseRoute.post("/makeunavailable", makeCourseUnavailableController)

module.exports = courseRoute