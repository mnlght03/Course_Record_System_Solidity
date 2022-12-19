const CourseSystem = require("../../models/CourseSystem")

async function addAdminController(req, res) {
  if (!req.body.newAdminAddress)
    return res.status(400).send("newAdminAddress not specified")
  const newAdmin = req.body.newAdminAddress
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.addAdmin(newAdmin)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = addAdminController