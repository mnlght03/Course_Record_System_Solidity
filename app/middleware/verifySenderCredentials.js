module.exports = (req, res, next) => {
  if (!req.body.senderAddress)
    return res.status(400).send("senderAddress not specified")
  if (!req.body.privateKey)
    return res.status(400).send("privateKey not specified")
  next()
}
