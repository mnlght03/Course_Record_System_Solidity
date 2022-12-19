const express = require("express")

const requestsRoute = new express.Router()

const sendRequestController = require("../controllers/requests/sendRequestController")
const acceptRequestController = require("../controllers/requests/acceptRequestController")
const declineRequestController = require("../controllers/requests/declineRequestController")

requestsRoute.post("", sendRequestController)
requestsRoute.post("accept", acceptRequestController)
requestsRoute.post("decline", declineRequestController)

module.exports = requestsRoute