defmodule MixpanelClientEx do
  alias MixpanelClientEx.RawClient
  
  defp random_string(size) do
    1..size |> Enum.map(fn(_) -> Enum.random(?a..?z) end) |> to_string()
  end
  
  defp token do
    Application.get_env(:mixpanel_client_ex, :token)
  end

  defp is_active do
    Application.get_env(:mixpanel_client_ex, :active) == true
  end
  

  @doc """
  Track an Event

  ## Parameters

    - event: String that represents the name of the tracked event.
    - distinct_id: String that represents the id of the tracked user.
    - properties: Map containing all metadata you want to associate to the event

  ## Examples

      MixpanelClientEx.track("User logged in", "user-42")
      MixpanelClientEx.track("User logged in", "user-42", %{"source" => "mobile_app"})
      MixpanelClientEx.track("User logged in", "user-42", %{"source" => "mobile_app", "time" => 1640991600})

  """
  @spec track(String.t(), String.t()) :: Task.t()
  def track event, distinct_id do
    track event, distinct_id, %{}
  end

  @spec track(String.t(), String.t(), map()) :: Task.t()
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
    if is_active() do
      RawClient.track(event, full_properties)
    else
      {:ok, "Skipped as active"}
    end
  end

  @doc """
  Set properties on a profile

  ## Parameters

    - distinct_id: String that represents the id of the profile.
    - properties: Map containing all metadata you want to associate to the profile

  ## Examples

      MixpanelClientEx.engage("user-42", %{"$email" => "john@doe.com"})

  """
  @spec engage(String.t(), map()) :: Task.t()
  def engage distinct_id, properties do
    if is_active() do
      RawClient.engage_set(token(), distinct_id, properties)
    else
      {:ok, "Skipped as active"}
    end
  end
end
