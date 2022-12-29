const CourseSystem = require("../../models/CourseSystem")

async function addCourseController(req, res) {
  if (!req.body.newCourseName)
    return res.status(400).send("newCourseName not specified")
  const newCourse = req.body.newCourseName
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.addCourse(newCourse)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = addCourseController