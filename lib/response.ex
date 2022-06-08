defmodule Ribbonex.Response do
  defstruct [
    :status,
    :http_response,
    :data,
    :request,
    :additional_properties
  ]

  @type t :: %__MODULE__{
          status: number(),
          http_response: Finch.Response.t(),
          data: any,
          request: Finch.Request.t(),
          additional_properties: any
        }

  def parse(response_tuple, additional_properties \\ [])
  def parse({:error, http_response}, _additional_properties), do: {:error, http_response}

  def parse({:ok, http_response}, additional_properties) do
    body = decode(http_response)
    data = extract_data(body)

    {:ok, build_response(http_response, data, additional_properties)}
  end

  defp decode(%Finch.Response{body: ""}), do: nil
  defp decode(%Finch.Response{body: body}), do: json_decode!(body)

  defp extract_data(%{"data" => data}), do: data
  defp extract_data(data), do: data

  defp build_response(http_response, data, additional_properties) do
    _headers = Enum.into(http_response.headers, %{})
    additional_properties = Enum.into(additional_properties, %{})

    %__MODULE__{
      status: http_response.status,
      http_response: http_response,
      data: data,
      request: Map.get(additional_properties, :request),
      additional_properties: Map.delete(additional_properties, :request)
    }
  end

  defp json_decode!(""), do: nil
  defp json_decode!(nil), do: nil
  defp json_decode!(%{} = body), do: body
  defp json_decode!(body) when is_binary(body), do: Jason.decode!(body)
end
