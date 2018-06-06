defmodule Throttle.Handler do

  require Logger

  use Riverside, otp_app: :throttle

  @userdb %{
    "taro" => %{
      password:  "foobar",
      user_id:  1
    },
    "jiro" => %{
      password:  "barbuz",
      user_id:  2
    }
  }

  @impl Riverside.Behaviour
  def authenticate(req) do

    {username, password} = req.basic

    Logger.info "<Throttle.Handler> authenticate"

    case do_authenticate(username, password) do

      {:ok, user_id} ->
        state = %{}
        {:ok, user_id, state}

      {:error, _reason} ->
          error = auth_error_with_code(401)
          {:error, error}
    end

  end

  def do_authenticate(username, password) do
    case Map.get(@userdb, username) do

      nil -> {:error, :unknown_user}

      user ->
        if user[:password] == password do
          {:ok, user[:user_id]}
        else
          {:error, :invalid_password}
        end

    end
  end

  @impl Riverside.Behaviour
  def init(session, state) do

    Logger.info "<Throttle.Handler> init"

    Roulette.sub("test_u:#{session.user_id}")
    Roulette.sub("test_s:#{session.user_id}/#{session.id}")

    {:ok, session, state}
  end

  @impl Riverside.Behaviour
  def handle_info({:pubsub_message, topic, data, _pid}, session, state) do

    Logger.info "<Throttle.Handler> received message"

    msg = Poison.decode!(data)

    deliver_me(msg)

    {:ok, session, state}
  end

  @impl Riverside.Behaviour
  def handle_message(msg, session, state) do

    Logger.info "<Throttle.Handler> handle_message"

    dest    = msg["to"]
    content = msg["content"]

    topic = "test_u:#{dest}"

    Roulette.pub(topic, Poison.encode!(%{
      from:    session.user_id,
      content: content,
    }))

    {:ok, session, state}
  end

  @impl Riverside.Behaviour
  def terminate(reason, session, state) do
    Logger.info "<Throttle.Handler> terminate"
    :ok
  end

end
