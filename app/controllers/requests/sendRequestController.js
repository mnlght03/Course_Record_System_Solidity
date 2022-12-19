const CourseSystem = require("../../models/CourseSystem")

async function sendRequestController(req, res) {
  if (!req.body.courseId)
    return res.status(400).send("courseId not specified")
  const courseId = req.body.courseId
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.requestToJoinCourse(courseId)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = sendRequestController