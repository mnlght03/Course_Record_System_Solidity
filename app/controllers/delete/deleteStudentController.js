const CourseSystem = require("../../models/CourseSystem")

async function deleteStudentController(req, res) {
  if (!req.body.studentAddress)
    return res.status(400).send("studentAddress not specified")
  const studentAddress = req.body.studentAddress
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.deleteStudent(studentAddress)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = deleteStudentController