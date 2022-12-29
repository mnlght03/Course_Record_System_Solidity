const CourseSystem = require("../../models/CourseSystem")

async function insertCourseController(req, res) {
  if (!req.body.courseId)
    return res.status(400).send("courseId not specified")
  if (!req.body.day)
    return res.status(400).send("day not specified")
  if (!req.body.numberOfLesson)
    return res.status(400).send("numberOfLesson not specified")
  const courseId = req.body.courseId
  const day = req.body.day
  const numberOfLesson = req.body.numberOfLesson
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.insertCourseInTimetable(courseId, day, numberOfLesson)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = insertCourseController