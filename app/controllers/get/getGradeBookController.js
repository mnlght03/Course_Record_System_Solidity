const CourseSystem = require("../../models/CourseSystem")

async function getGradeBookController(req, res) {
  if (!req.body.courseId)
    return res.status(400).send("courseId not specified")
  if (!req.body.studentAddress)
    return res.status(400).send("studentAddress not specified")
  if (!req.body.startDate)
    return res.status(400).send("startDate not specified")
  if (!req.body.endDate)
    return res.status(400).send("endDate not specified")
  const courseId = req.body.courseId
  const studentAddress = req.body.studentAddress
  const startDate = req.body.startDate
  const endDate = req.body.endDate
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.getGradeBook(courseId, studentAddress,
                                                   startDate, endDate)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = getGradeBookController