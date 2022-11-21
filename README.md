# MixpanelClientEx
This is a basic implementation on Mixpanel ingestion API (https://developer.mixpanel.com/reference/ingestion-api), allowing you to track events and set profile properties from an Elixir app.

## Reference
See [on hexdocs](https://hexdocs.pm/mixpanel_client_ex)

## Installation

```elixir
def deps do
  [
    {:mixpanel_client_ex, "~> 1.1.0"}
  ]
end

config :mixpanel_client_ex,
    token: "***-your-token",
    active: true
```

## Basic Usage

```
# Tracking, no properties
MixpanelClientEx.track("User logged in", "user-42")

# Tracking, custom properties
MixpanelClientEx.track("User logged in", "user-42", %{"source" => "mobile_app"})

# Engage a profile
MixpanelClientEx.engage("user-42", %{"$email" => "john@doe.com"})
```

## Custom usage
```
# Tracking, override time or $insert_id
MixpanelClientEx.track("User logged in", "user-42", %{"source" => "mobile_app", "time" => 1640991600})
```
