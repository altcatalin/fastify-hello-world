'use strict'

const server = require('./app')({
  logger: {
    level: 'info'
  },
})

server.listen({ port: 3000 }, (err, address) => {
  if (err) {
    server.log.error(err)
    process.exit(1)
  }
})
