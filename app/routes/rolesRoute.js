const express = require("express")

const rolesRoute = new express.Router()

const getRoleController = require("../controllers/roles/getRoleController")

rolesRoute.get("", getRoleController)

module.exports = rolesRoute