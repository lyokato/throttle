use Mix.Config

config :throttle, Throttle.Pubsub,
  connection: [
    servers: [
      [host: "127.0.0.1", port: 4222],
      #[host: "new-dev-nlb-nats-01-b12f1cb738f2819c.elb.ap-northeast-1.amazonaws.com", port: 4222],
      #[host: "172.28.1.129", port: 4222]
      #[host: "staging-nlb-nats-01-c541d7b0c72c136d.elb.ap-northeast-1.amazonaws.com", port: 4222],
      #[host: "staging-nlb-nats-02-ccc64bb9e3d17010.elb.ap-northeast-1.amazonaws.com", port: 4222]
    ],
    max_ping_failure: 2,
    ping_interval: 1000,
    pool_size: 2,
    show_debug_log: true
  ],
  publisher: [
    show_debug_log: true
  ],
  subscriber: [
    show_debug_log: true
  ]

config :throttle, Throttle.Handler,
  port: 3333,
  path: "/ws",
  show_debug_logs: true,
  transmission_limit: [
    capacity: 50,
    duration: 2_000
  ]

config :logger,
  level: :debug
