const Parser = require('rss-parser')

const parseRSS = async (feedLink) =>{
    let parser = new Parser()

    let feed = await parser.parseURL(feedLink)

    const items = feed.items.map((item) =>{
        return {
            title: item.title,
            description: item.contentSnippet,
            author: item.creator,
            categories: item.categories,
            date: item.isoDate,
            link: item.link
        }
    })

    return {
        title: feed.title,
        image: feed?.image?.url,
        description: feed.description,
        items: items
    }
}

module.exports = {parseRSS}