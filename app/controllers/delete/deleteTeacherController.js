const CourseSystem = require("../../models/CourseSystem")

async function deleteTeacherController(req, res) {
  if (!req.body.teacherAddress)
    return res.status(400).send("teacherAddress not specified")
  const teacherAddress = req.body.teacherAddress
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.deleteTeacher(teacherAddress)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = deleteTeacherController