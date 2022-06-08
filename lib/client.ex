defmodule Ribbonex.Client do
  def child_spec(opts \\ nil) do
    Finch.child_spec(name: __MODULE__, pools: default_pools(opts))
  end

  def default_pools(opts) when is_map(opts), do: opts

  def default_pools(_) do
    %{
      :default => [size: 10]
    }
  end

  def get(path, opts \\ []) do
    url = url(path) <> query_string(Access.get(opts, :params, []))
    headers = build_headers(opts)

    request = Finch.build(:get, url, Enum.into(headers, []))

    request
    |> do_request()
    |> Ribbonex.Response.parse(request: request)
  end

  def authd_get(path, opts \\ []) do
    opts = put_header(opts, "Authorization", "Token #{access_token()}")
    get(path, opts)
  end

  def post(path, params, opts \\ []) do
    url = url(path)
    headers = build_headers(opts)
    body = encode_body(params, headers)

    request = Finch.build(:post, url, Enum.into(headers, []), body)

    request
    |> do_request()
    |> Ribbonex.Response.parse(request: request)
  end

  def authd_post(path, params, opts \\ []) do
    opts = put_header(opts, "Authorization", "Token #{access_token()}")
    post(path, params, opts)
  end

  def put(path, params, opts \\ []) do
    url = url(path)
    headers = build_headers(opts)
    body = encode_body(params, headers)

    request = Finch.build(:put, url, Enum.into(headers, []), body)

    request
    |> do_request()
    |> Ribbonex.Response.parse(request: request)
  end

  def delete(path, opts \\ []) do
    url = url(path) <> query_string(Access.get(opts, :params, []))
    headers = build_headers(opts)

    request = Finch.build(:delete, url, Enum.into(headers, []))

    request
    |> do_request()
    |> Ribbonex.Response.parse(request: request)
  end

  def build_headers(opts) do
    case Access.get(opts, :headers) do
      nil -> base_headers()
      headers -> Map.merge(base_headers(), Enum.into(headers, %{}))
    end
  end

  def encode_body(%{} = params, %{"content-type" => "application/x-www-form-urlencoded"}) do
    URI.encode_query(params)
  end

  def encode_body(params, %{"content-type" => "application/json"}) do
    Jason.encode!(params)
  end

  def do_request(%Finch.Request{} = request) do
    Finch.request(request, __MODULE__)
  end

  def url(path) do
    Path.join(api_host(), path)
  end

  @spec base_headers :: [{String.t(), String.t()}, ...]
  def base_headers do
    %{
      "accept" => "application/json",
      "content-type" => "application/json"
    }
  end

  def api_host do
    Application.get_env(
      :ribbonex,
      :base_url,
      "https://api.ribbonhealth.com"
    )
  end

  defp put_header(opts, key, value) when is_list(opts) do
    headers = Access.get(opts, :headers, %{})
    headers = Map.put(headers, key, value)
    Keyword.put(opts, :headers, headers)
  end

  defp query_string([]), do: ""

  defp query_string(params) when is_list(params) do
    "?" <> Ribbonex.Query.encode(params)
  end

  defp query_string(params) when is_map(params) do
    "?" <> Ribbonex.Query.encode(params)
  end

  defp query_string(_), do: ""

  defp access_token do
    Application.get_env(:ribbonex, :token) ||
      raise RuntimeError, message: "You must set a config value for `ribbonex: :token`"
  end
end
