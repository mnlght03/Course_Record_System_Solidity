const CourseSystem = require("../../models/CourseSystem")

async function deleteCourseFromTimetableController(req, res) {
  if (!req.body.day)
    return res.status(400).send("day not specified")
  if (!req.body.numberOfLesson)
    return res.status(400).send("numberOfLesson not specified")
  const day = req.body.day
  const numberOfLesson = req.body.numberOfLesson
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.deleteCourseFromTimetableController(day, numberOfLesson)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = deleteCourseFromTimetableController