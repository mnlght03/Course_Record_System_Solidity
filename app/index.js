const express = require("express")
const cors = require("cors")
const bodyParser = require("body-parser")

const app = new express()

const port = process.env.PORT || 3000

app.use(cors())
app.use(bodyParser.urlencoded({extended: false}))
app.use(bodyParser.json())

const addRoute = require("./routes/addRoute");
const deleteRoute = require("./routes/deleteRoute")
const rolesRoute = require("./routes/rolesRoute");
const requestsRoute = require("./routes/requestsRoute");
const assignRoute = require("./routes/assignRoute");
const unassignRoute = require("./routes/unassignRoute");
const getRoute = require("./routes/getRoute");
const teacherRoute = require("./routes/teacherRoute");
const timetableRoute = require("./routes/timetableRoute")
const courseRoute = require("./routes/courseRoute")


const verifySenderCredentials = require("./middleware/verifySenderCredentials")

app.use(verifySenderCredentials)

app.use("/add", addRoute)
app.use("/delete", deleteRoute)
app.use("/role", rolesRoute)
app.use("/request", requestsRoute)
app.use("/assign", assignRoute)
app.use("/unassign", unassignRoute)
app.use("/get", getRoute)
app.use("/teacher", teacherRoute)
app.use("/timetable", timetableRoute)
app.use("/course", courseRoute)

app.use((req, res) => res.sendStatus(404))

app.listen(port, () => {
  console.log("server listening on port ", port)
})

module.exports = app