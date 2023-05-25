defmodule Ribbonex.Providers do
  @moduledoc """
  Welcome to the Provider Endpoints! These endpoints allow you to build new applications leveraging Ribbon Health provider information to find providers, to learn more about a specific provider, and even to book online appointments.

  The endpoints provide information on any provider in the United States, ranging from the basics like location & contact information to granular detailed information like insurances accepted and patient satisfaction.

  A few specific applications of the endpoints include:

  - Search for providers per specific criteria
  - Recommend providers based on key parameters
  - Build detailed profiles of specific providers
  - Find facilities where specific providers practice
  - Verify a provider's accepted insurances in real-time
  - Book doctor appointments
  - Build custom provider directories & networks

  ### Reference
  [Ribbon Docs](https://ribbon.readme.io/docs/overview-of-the-custom-endpoint)
  """

  @provider_search_params [
    page: [type: :non_neg_integer],
    npi: [
      type: :string,
      doc: ""
    ],
    name: [
      type: :string,
      doc: "String input of a full, first, last, or partial name."
    ],
    address: [
      type: :string,
      doc: "String input of an address that will be interpreted and geocoded in real time."
    ],
    distance: [
      type: :integer,
      doc:
        "Integer input (0-50) that shows the proximity radius of doctors displayed."
    ],
     min_location_confidence: [
      type: :integer,
      doc:
        "Integer input (0-5) of the minimum confidence threshold for returned provider locations."
    ],
    specialty_ids: [
      type: {:list, :string},
      doc:
        "Comma separated list of desired specialty uuids. See all providers who specialize in the given specialties."
    ],
    insurance_ids: [
      type: {:list, :string},
      doc: "List of desired insurance uuids. See all providers who accept a given insurance(s)."
    ],
    location_ids: [
      type: {:list, :string},
      doc: "List of desired locations uuids. See all providers who belongs to a given location(s)."
    ],
    fields: [
      type: {:list, :string},
      doc: "Fields to include in response."
    ],
    _excl_fields: [
      type: {:list, :string},
      doc: "Fields to exclude in response."
    ],
    custom_filters: [
      type: :keyword_list,
      doc: "Custom provider filters"
    ],
    distance: [
      type: :integer,
      doc: "Proximity radius of doctors displayed."
    ],
    location_within_distance: [
      type: :boolean,
      doc: "Set to true to exclude providers' locations that are outside of the search radius"
    ]
  ]

  def search(params \\ []) do
    with {:ok, params} <- NimbleOptions.validate(Enum.into(params, []), @provider_search_params) do
      path = "/v1/custom/providers"
      # Apply custom filters if they're available
      params =
        case params[:custom_filters] do
          nil ->
            params

          custom_filters ->
            custom_filters
            |> Keyword.merge(params)
            |> Keyword.delete(:custom_filters)
        end
      Ribbonex.Client.authd_get(path, params: params)
    end
  end

  def get_provider(npi, params \\ []) when is_binary(npi) do
    path = "/v1/custom/providers/" <> npi
    Ribbonex.Client.authd_get(path, params: params)
  end
end
