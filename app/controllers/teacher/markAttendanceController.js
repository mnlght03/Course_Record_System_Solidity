const CourseSystem = require("../../models/CourseSystem")

async function markAttendanceController(req, res) {
  if (!req.body.courseId)
    return res.status(400).send("courseId not specified")
  if (!req.body.studentAddress)
    return res.status(400).send("studentAddress not specified")
  if (!req.body.date)
    return res.status(400).send("date not specified")
  if (!req.body.status)
    return res.status(400).send("status not specified")
  const courseId = req.body.courseId
  const studentAddress = req.body.studentAddress
  const date = req.body.date
  const status = req.body.status
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.markAttendance(date, courseId, studentAddress, status)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = markAttendanceController