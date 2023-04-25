const mongoose = require('mongoose')
const Schema = mongoose.Schema

const userFeedsSchema = new Schema({
  user: {type: Schema.Types.ObjectId, ref: 'User',},
  feeds: [{ type: Schema.Types.ObjectId, ref: 'Feed' }],
})

module.exports = mongoose.model('UserFeeds', userFeedsSchema)
