defmodule Throttle.Handler do

  require Logger
  alias Throttle.Pubsub

  use Riverside, otp_app: :throttle

  @userdb %{
    "taro" => %{
      password:  "foobar",
      user_id:  1
    },
    "jiro" => %{
      password:  "barbuz",
      user_id:  2
    },
    "saburo" => %{
      password:  "buzfoo",
      user_id:  3
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

  defp do_authenticate(username, password) do
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

    Pubsub.sub("test_u:1")
    Pubsub.sub("test_u:2")
    Pubsub.sub("test_u:3")
    Pubsub.sub("test_s:#{session.user_id}/#{session.id}")

    #(0..100) |> Enum.each(fn _idx ->
    #  r = SecureRandom.hex(20)
    #  Pubsub.sub("test_u:dummy:#{r}")
    #end)

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

    Pubsub.pub(topic, Poison.encode!(%{
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
