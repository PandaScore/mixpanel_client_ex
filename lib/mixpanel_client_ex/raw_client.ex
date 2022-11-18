defmodule MixpanelClientEx.RawClient do
    use Tesla
    plug Tesla.Middleware.Headers, [{"content-type", "application/json"}]
    plug Tesla.Middleware.JSON
    plug Tesla.Middleware.BaseUrl, "https://api.mixpanel.com"
  
    def track event, properties do
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
  
    def engage_set token, distinct_id, set do
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
end
  