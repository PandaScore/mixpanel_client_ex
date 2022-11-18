import Config

if config_env() == :test do
  config :tesla, adapter: Tesla.MockAdapter
  config :mixpanel_client_ex,
    token: "test-token",
    active: true
else
  config :tesla, adapter: Tesla.Adapter.Hackney
end
