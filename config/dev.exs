use Mix.Config

config :roulette, :connection,
  ring: [
    [host: "127.0.0.1", port: 4222],
  ],
  max_ping_failure: 3,
  ping_interval: 10000,
  pool_size: 5

config :throttle, Throttle.Handler,
  port: 3333,
  path: "/ws",
  show_debug_logs: true,
  transmission_limit: [
    capacity: 50,
    duration: 2_000
  ]

config :logger,
  level: :warn
