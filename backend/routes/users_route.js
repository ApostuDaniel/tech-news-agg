const express = require('express')
const jwt = require('jsonwebtoken')
const crypto = require('crypto')
const User = require('../models/user.js')
const UserFeeds = require('../models/user_feeds.js')
const { SECRET_KEY } = require('../config.js')

const router = express.Router()

router.post('/signup', async (req, res) => {
    console.log(req.body.username + ' attempted signup')
    try{
        const user = await User.findOne({ email: req.body.email })
        if(user == null){
            const password = crypto.createHash('sha256').update(req.body.password).digest('hex');

            try{
              const result = await User.create({
                username: req.body.username,
                email: req.body.email,
                password: password,
              })

              const userFeeds = await UserFeeds.create({
                user: result.id,
                feeds: []
              })
              
              res.status(201).json({ message: 'User registered' })
            }
            catch(err){
              console.log(err)
              res.status(422).json({ message: err.message })
              return
            }
        }
        else{
            res.status(409).json({ message: "User with this email is already registered" })
        }
    }
    catch(err){
        console.log(err)
        res.status(500).json({message: err.message})
    }
})

router.post('/login', async (req, res) => {
    console.log(req.body.username + ' attempted login')
    const password = crypto
      .createHash('sha256')
      .update(req.body.password)
      .digest('hex')

    try{
        const user = await User.findOne({
            email: req.body.email,
            password: password,
        })

        if(user != null){
            const payload = {
                username: user.username,
                userId: user.id
            }

            const token = jwt.sign(payload, SECRET_KEY(), {
              algorithm: 'HS256',
              expiresIn: '15d',
            })
            console.log("Success")
            res.status(200).json({message: "Success", token: token})
        }
        else{
            console.log("Failure")
            res.status(401).json({message: "User not found, wrong password or username"})
        }
    }
    catch(err){
        console.log(err)
        res.status(500).json({ message: err.message })
    }
})

router.get('/data', function(req, res) {
  var token = req.get('Authorization');
  try {
    jwt.verify(token, SECRET_KEY(), {algorithm: 'HS256'});
    res.status(200).json({message: "Very Secret Data"});
  } catch {
    res.status(401);
    res.send("Bad Token");
  }
})

module.exports = router
