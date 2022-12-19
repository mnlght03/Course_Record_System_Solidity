const CourseSystem = require("../../models/CourseSystem")

async function getTimetableController(req, res) {
  if (!req.body.courseId)
    return res.status(400).send("courseId not specified")
  if (!req.body.studentAddress)
    return res.status(400).send("studentAddress not specified")
  if (!req.body.teacherAddress)
    return res.status(400).send("teacherAddress not specified")
  const courseId = req.body.courseId
  const studentAddress = req.body.studentAddress
  const teacherAddress = req.body.teacherAddress
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.getTimetable(courseId, studentAddress, teacherAddress)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = getTimetableController