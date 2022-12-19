const CourseSystem = require("../../models/CourseSystem")

async function acceptRequestController(req, res) {
  if (!req.body.studentAddress)
    return res.status(400).send("studentAddress not specified")
    if (!req.body.courseId)
    return res.status(400).send("courseId not specified")
  const studentAddress = req.body.studentAddress
  const courseId = req.body.courseId
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.acceptRequest(studentAddress, courseId)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = acceptRequestController