const CourseSystem = require("../../models/CourseSystem")

async function addGroupController(req, res) {
  if (!req.body.newGroupId)
    return res.status(400).send("newGroupId not specified")
  const newGroup = req.body.newGroupId
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.addGroup(newGroup)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = addGroupController