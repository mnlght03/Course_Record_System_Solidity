const CourseSystem = require("../../models/CourseSystem")

async function addStudentController(req, res) {
  if (!req.body.newStudentAddress)
    return res.status(400).send("newStudentAddress not specified")
  if (!req.body.groupId)
    return res.status(400).send("groupId not specified")
  const newStudent = req.body.newStudentAddress
  const groupId = req.body.groupId
  const senderAddress = req.body.senderAddress
  const privateKey = req.body.privateKey
  try {
    const courseSystem = new CourseSystem(senderAddress, privateKey)
    const result = await courseSystem.addStudent(newStudent, groupId)
    return res.status(200).send(result)
  } catch(err) {
    return res.send(err)
  }
}

module.exports = addStudentController