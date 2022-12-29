const CourseSystem = require("../../models/CourseSystem")

async function makeCourseUnavailableController(req, res) {
  if (!req.body.courseId)
    return res.status(400).send("courseId not specified")
  if (!req.body.groupId)
    return res.status(400).send("groupId not specified")
  const courseId = req.body.courseId
  const groupId = req.body.groupId
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.makeCourseUnavailableForGroup(courseId, groupId)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = makeCourseUnavailableController