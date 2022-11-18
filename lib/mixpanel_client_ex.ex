defmodule MixpanelClientEx do
  use Tesla
  plug Tesla.Middleware.Headers, [{"content-type", "application/json"}]
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.BaseUrl, "https://api.mixpanel.com"

  defp random_string(size) do
    1..size |> Enum.map(fn(_) -> Enum.random(?a..?z) end) |> to_string()
  end
  
  defp token do
    Application.get_env(:mixpanel_client_ex, :token)
  end

  defp raw_track event, properties do
    post(
      "/track",
      [
        %{
          "event" => event,
          "properties" => properties
        }
      ]
    )
  end

  defp raw_engage_set token, distinct_id, set do
    post(
      "/engage#profile-set",
      [
        %{
          "$token" => token,
          "$distinct_id" => distinct_id,
          "$set" => set,
          "$ignore_time" => "true",
          "$ip" => "0"
        }
      ]
    )
  end

  def track event, distinct_id do
    track event, distinct_id, %{}
  end

  def track event, distinct_id, properties do
    full_properties = Map.merge(
      %{
        "token" => token(),
        "time" => System.system_time(:millisecond),
        "distinct_id" => distinct_id,
        "$insert_id" => random_string(32)
      },
      properties
    )
    Task.async(fn -> raw_track(event, full_properties) end)
  end

  def engage distinct_id, properties do
    Task.async(fn -> raw_engage_set(token(), distinct_id, properties) end)
  end
end
