const CourseSystem = require("../../models/CourseSystem")

async function addTeacherController(req, res) {
  if (!req.body.newTeacherAddress)
    return res.status(400).send("newTeacherAddress not specified")
  const newTeacher = req.body.newTeacherAddress
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.addTeacher(newTeacher)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = addTeacherController