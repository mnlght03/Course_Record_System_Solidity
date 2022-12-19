const CourseSystem = require("../../models/CourseSystem")

async function rateAssignmentController(req, res) {
  if (!req.body.courseId)
    return res.status(400).send("courseId not specified")
  if (!req.body.studentAddress)
    return res.status(400).send("studentAddress not specified")
  if (!req.body.date)
    return res.status(400).send("date not specified")
  if (!req.body.grade)
    return res.status(400).send("grade not specified")
  const courseId = req.body.courseId
  const studentAddress = req.body.studentAddress
  const date = req.body.date
  const grade = req.body.grade
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.rateAssignment(date, courseId, studentAddress, grade)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = rateAssignmentController