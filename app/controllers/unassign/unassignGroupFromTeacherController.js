const CourseSystem = require("../../models/CourseSystem")

async function unassignGroupFromTeacherController(req, res) {
  if (!req.body.teacherAddress)
    return res.status(400).send("teacherAddress not specified")
  if (!req.body.groupId)
    return res.status(400).send("groupId not specified")
  if (!req.body.courseId)
    return res.status(400).send("courseId not specified")
  const teacher = req.body.teacherAddress
  const groupId = req.body.groupId
  const courseId = req.body.courseId
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.unassignGroupFromCourseTeacher(groupId, courseId, teacher)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = unassignGroupFromTeacherController