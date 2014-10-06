express = require 'express'
app = express()

# Jade views served from views directory
app.set 'views', './views'
app.set 'view engine', 'jade'

# Use connect-assets to compile and serve assets in place
connect = require("connect-assets")()
app.use connect

# Static assets from public and bower directories
app.use( express.static 'public' )
app.use( express.static 'bower_components' )

app.get '/', (req, res) =>
  res.render 'index', { title: 'Hey', message: 'Hello there!' }

server = app.listen 3000, =>
  console.log 'Listening on port %d', server.address().port
