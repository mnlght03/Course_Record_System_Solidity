const CourseSystem = require("../../models/CourseSystem")

async function getCourseIdController(req, res) {
  if (!req.body.courseName)
    return res.status(400).send("courseName not specified")
  const courseName = req.body.courseName
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.getCourseId(courseName)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = getCourseIdController