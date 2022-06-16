defmodule Ribbonex.Response do
  defstruct [
    :status,
    :http_response,
    :parameters,
    :data,
    :end_of_list,
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
    parameters = extract_parameters(body)

    response =
      build_response(http_response, data, additional_properties)
      |> Map.put(:parameters, parameters)
      |> Map.put(:end_of_list, end_of_list?(parameters))

    {:ok, response}
  end

  defp decode(%Finch.Response{body: ""}), do: nil
  defp decode(%Finch.Response{body: body}), do: json_decode!(body)

  defp extract_data(%{"data" => data}), do: data
  defp extract_data(data), do: data

  defp extract_parameters(%{"parameters" => parameters}), do: parameters
  defp extract_parameters(_), do: nil

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

  defp end_of_list?(nil), do: true
  defp end_of_list?(%{"total_count" => 0}), do: true

  defp end_of_list?(parameters) when is_map(parameters) do
    page = Map.get(parameters, "page", 1)
    page_size = Map.get(parameters, "page_size", 25)
    total_count = Map.get(parameters, "total_count", 0)

    page * page_size >= total_count
  end
end
