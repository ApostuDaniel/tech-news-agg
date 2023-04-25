const mongoose = require('mongoose')
const Schema = mongoose.Schema

const userSchema = new Schema({
  username: {
    type: String,
    required: true,
    validate: {
      validator: (username) => username.length > 4,
      message: (props) => `Username ${props} must have length longer that 4`,
    },
  },
  email: {
    type: String,
    required: true,
    lowercase: true,
    unique: true,
    validate: {
      validator: (email) =>
        String(email)
          .toLocaleLowerCase()
          .match(
            /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
          ),
      message: (props) => `${props} deemed invalid by email regex`,
    },
  },
  password: {
    type: String,
    required: true,
    validate: {
      validator: (password) => password.length > 4,
      message: (props) => `Password must have length longer that 4`,
    },
  },
})

module.exports = mongoose.model('User', userSchema)
