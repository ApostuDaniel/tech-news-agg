const express = require('express')
const jwt = require('jsonwebtoken')
const crypto = require('crypto')
const Feed = require('../models/feed.js')
const UserFeeds = require('../models/user_feeds.js')
const { SECRET_KEY } = require('../config.js')
const {parseRSS} = require("../services/rss_parser.js")

const router = express.Router()

router.post('/feeds', async (req, res) => {
    try {
      const feed = await Feed.findOne({ feed_link: req.body.feed_link })
      if (feed == null) {
        try {
          const result = await Feed.create({
            name: req.body.name,
            feed_link: req.body.feed_link,
            image_link: req.body.image_link,
          })

          res.status(201).json({ message: 'Feed created' })
        } catch (err) {
          console.log(err)
          res.status(422).json({ message: err.message })
          return
        }
      } else {
        res
          .status(409)
          .json({ message: 'Feed already exists' })
      }
    } catch (err) {
      console.log(err)
      res.status(500).json({ message: err.message })
    }
})

router.get('/feeds', async (req, res) => {
  try {
    const feeds = await Feed.find();
    res.send(feeds)
  } catch (err) {
    console.log(err)
    res.status(500).json({ message: err.message })
  }
})

router.get('/feeds/:userId', async (req, res) => {
  const token = req.get('Authorization')
  const userId = req.params.userId
  try {
    jwt.verify(token, SECRET_KEY(), { algorithm: 'HS256' })

    const decoding = jwt.decode(token);

    if(userId != decoding.userId){
        throw new Error("Trying to access information of other user than the one authorized")
    }

    let userFeeds = await UserFeeds.findOne({ user: userId }).populate('feeds')
    
    res.send(userFeeds)
  } catch(err) {
    res.status(401)
    res.send(err.message)
  }
})

router.put('/feeds/:userId', async (req, res) => {
  const token = req.get('Authorization')
  const userId = req.params.userId
  try {
    jwt.verify(token, SECRET_KEY(), { algorithm: 'HS256' })

    const decoding = jwt.decode(token)

    if (userId != decoding.userId) {
      throw new Error(
        'Trying to access information of other user than the one authorized'
      )
    }

    let userFeeds = await UserFeeds.findOne({ user: userId })

    if (userFeeds == null) {
      res.status(404).json({message: "User does not have a UserFeeds"})
    }

    userFeeds = await UserFeeds.updateOne(
      { user: userId },
      { feeds: req.body.feeds }
    )

    res.status(204).send()
  } catch (err) {
    res.status(401)
    res.send(err.message)
  }
})

router.get('/feed-content', async (req, res) => {
    let feedLink = req.query.feed_link

    if(feedLink == null){
        res.status(404).json({message: "feed_link query parameter not provided"})
    }

    const feedContent = await parseRSS(feedLink)

    res.send(feedContent)
})


module.exports = router