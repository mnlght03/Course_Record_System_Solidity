const CourseSystem = require("../../models/CourseSystem")

async function deleteAdminController(req, res) {
  if (!req.body.adminAddress)
    return res.status(400).send("adminAddress not specified")
  const admin = req.body.adminAddress
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.deleteAdmin(admin)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = deleteAdminController