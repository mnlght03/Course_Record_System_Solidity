const CourseSystem = require("../../models/CourseSystem")

async function deleteCourseController(req, res) {
  if (!req.body.courseId)
    return res.status(400).send("courseId not specified")
  const course = req.body.courseId
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.deleteCourse(course)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = deleteCourseController