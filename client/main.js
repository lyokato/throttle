const WebSocket = require('ws');

const username = "taro"
const password = "foobar"
const port     = 3333
const path     = "/ws"


let ws = null;

function start() {
  console.log('start.')
  const url = buildURL(username, password, port, path)
  ws = new WebSocket(url)
  setEventHandlers(ws)
}

function setEventHandlers(ws) {
  ws.on('open', () => {
    console.log('socket opened')
    for (let i = 0; i < 50; i++) {
      ws.send(buildMSG(1, "Hello!" + i.toString()))
    }
  })

  ws.on('close', () => {
    console.log('closed.')
    start()
  })

  ws.on('message', (data) => {
    msg = JSON.parse(data)
    console.log(`received ${msg.from} - ${msg.content}`)
  })

}

function buildURL(username, password, port, path) {
  return `ws://${username}:${password}@localhost:${port}${path}`
}

function buildMSG(user_id, content) {
  return JSON.stringify({
    to:      user_id,
    content: content
  })
}

start()
