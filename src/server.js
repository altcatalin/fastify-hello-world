'use strict'

const server = require('./app')({
  logger: {
    level: 'info'
  },
})

server.listen({ port: parseInt(process.env.PORT, 10) || 3000, host: '0.0.0.0' }, (err, address) => {
  if (err) {
    server.log.error(err)
    process.exit(1)
  }
})
