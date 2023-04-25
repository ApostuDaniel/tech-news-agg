const express = require('express')
const cors = require('cors')
const bodyParser = require('body-parser')

const app = express()
const port = 3000 || process.env.PORT


const mongoose = require('mongoose')
mongoose.connect('mongodb://127.0.0.1:27017/tech-news-agg', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})

app.use(cors())
app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())
app.use('/', require('./routes/users_route'), require('./routes/feed_route'))
app.listen(port, () => {
  console.log('port running on ' + port)
})
