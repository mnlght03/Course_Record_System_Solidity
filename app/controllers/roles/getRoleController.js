const CourseSystem = require("../../models/CourseSystem")

async function getRoleController(req, res) {
  if (!req.body.userAddress)
    return res.status(400).send("userAddress not specified")
  const userAddress = req.body.userAddress
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.roles(userAddress)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = getRoleController