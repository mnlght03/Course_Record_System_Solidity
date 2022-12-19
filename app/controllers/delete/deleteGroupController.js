const CourseSystem = require("../../models/CourseSystem")

async function deleteGroupController(req, res) {
  if (!req.body.groupId)
    return res.status(400).send("groupId not specified")
  const groupId = req.body.groupId
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.deleteGroupController(groupId)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = deleteGroupController