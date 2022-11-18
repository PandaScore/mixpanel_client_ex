defmodule MixpanelClientExTest do
  use ExUnit.Case
  import Mox

  test "[track] no properties mixpanel ok, returns a task answering :ok" do
    expect(
        Tesla.MockAdapter,
        :call,
        fn (%{body: json_body, method: method, url: url}, _opts) ->
          assert method == :post
          assert url == "https://api.mixpanel.com/track"
          {:ok, [event]} = Jason.decode(json_body)
          assert event["event"] == "User Logged In"
          assert event["properties"]["distinct_id"] == "user-42"
          assert event["properties"]["token"] == "test-token"

          assert String.length(event["properties"]["$insert_id"]) == 32
          assert event["properties"]["time"] > 1640991600

          {:ok, %{status: 200, headers: [], body: ""}}
        end
      )
    

    r = MixpanelClientEx.track("User Logged In", "user-42")
      |> Task.await()
    assert match?({:ok, _}, r)
  end

  test "[track] with properties mixpanel ok, returns a task answering :ok" do
    expect(
        Tesla.MockAdapter,
        :call,
        fn (%{body: json_body, method: :post, url: "https://api.mixpanel.com/track"}, _opts) ->
          {:ok, [event]} = Jason.decode(json_body)
          assert event["event"] == "User Logged In"
          assert event["properties"]["utm_source"] == "mobile_app"
          assert event["properties"]["time"] > 1640991600
          assert String.length(event["properties"]["$insert_id"]) == 32

          {:ok, %{status: 200, headers: [], body: ""}}
        end
      )

    r = MixpanelClientEx.track("User Logged In", "user-42", %{"utm_source" => "mobile_app"})
      |> Task.await()
    assert match?({:ok, _}, r)
  end

  test "[track] override time & $insert_id mixpanel ok, returns a task answering :ok" do
    expect(
        Tesla.MockAdapter,
        :call,
        fn (%{body: json_body, method: :post, url: "https://api.mixpanel.com/track"}, _opts) ->
          {:ok, [event]} = Jason.decode(json_body)
          assert event["event"] == "User Logged In"
          assert event["properties"]["utm_source"] == "mobile_app"
          assert event["properties"]["time"] == 1640991600
          assert event["properties"]["$insert_id"] == "my-own-insert-id"


          {:ok, %{status: 200, headers: [], body: ""}}
        end
      )

    r = MixpanelClientEx.track("User Logged In", "user-42", %{
      "utm_source" => "mobile_app",
      "time" => 1640991600,
      "$insert_id" => "my-own-insert-id"
      })
      |> Task.await()
    assert match?({:ok, _}, r)
  end

  

  test "[track] mixpanel not ok, returns a task answering :ok" do
    expect(
      Tesla.MockAdapter,
      :call,
      fn (%{method: :post, url: "https://api.mixpanel.com/track"}, _opts) ->
        {:error, %{status: 500, headers: [], body: ""}}
      end
    )
    
    r = MixpanelClientEx.track("User Logged In", "user-42")
      |> Task.await()
    assert match?({:error, _}, r)
  end

  test "[engage] mixpanel ok, returns a task answering :ok" do
    expect(
        Tesla.MockAdapter,
        :call,
        fn (%{body: json_body, method: method, url: url}, _opts) ->
          assert method == :post
          assert url == "https://api.mixpanel.com/engage#profile-set"
          {:ok, [event]} = Jason.decode(json_body)
          assert event["$distinct_id"] == "user-42"
          assert event["$token"] == "test-token"
          assert event["$ignore_time"] == "true"
          assert event["$ip"] == "0"
          assert event["$set"]["$email"] == "james@doe.com"

          {:ok, %{status: 200, headers: [], body: ""}}
        end
      )
    

    r = MixpanelClientEx.engage("user-42", %{"$email" => "james@doe.com" })
      |> Task.await()
    assert match?({:ok, _}, r)
  end

  test "[engage] mixpanel not ok, returns a task answering :error" do
    expect(
      Tesla.MockAdapter,
      :call,
      fn (%{method: :post, url: "https://api.mixpanel.com/engage#profile-set"}, _opts) ->
        {:error, %{status: 500, headers: [], body: ""}}
      end
    )
    

    r = MixpanelClientEx.engage("user-42", %{"$email" => "james@doe.com" })
      |> Task.await()
    assert match?({:error, _}, r)
  end
  
end

