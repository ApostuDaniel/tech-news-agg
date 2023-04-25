const mongoose = require('mongoose')
const Schema = mongoose.Schema

const feedSchema = new Schema({
  name: {
    type: String,
    required: true,
  },
  feed_link: {
    type: String,
    required: true,
  },
  image_link: String
})

module.exports = mongoose.model('Feed', feedSchema)
