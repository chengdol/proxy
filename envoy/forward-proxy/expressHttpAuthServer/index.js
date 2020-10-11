const express = require('express')
const auth = require('basic-auth')
const app = express()
const port = 8081

app.use((req, res, next) => {
  console.log(req.headers)
  console.log(auth(req))
  
  // check req is null or undefined
  if (auth(req) === null || typeof auth(req) === "undefined")
  {
    res.status(401)
    res.end('Unauthorized')
    return
  }
  const { name, pass } = auth(req)

  if(name === 'chengdol' && pass === '123456') {
    res.status(200)
    res.end()
  } else {
    res.status(401)
    res.end('Unauthorized')
  }
})

app.listen(port, () => console.log(`Example app listening on port ${port}!`))
