defmodule Ribbonex.Locations do
  @location_search_params [
    page: [type: :non_neg_integer],
    name: [
      type: :string,
      doc: "Fuzzy search on name."
    ],
    fields: [
      type: {:list, :string},
      doc: "Fields to include in response."
    ],
    address: [
      type: :string,
      doc: "String input of an address that will be interpreted and geocoded in real time."
    ],
    clinical_area: [
      type: :string,
      doc: "Fuzzy search on clinical area."
    ],
    distance: [
      type: :integer,
      doc: "Proximity radius of doctors displayed."
    ],
  ]

  def get_location(uuid, params \\ []) do
    path = "/v1/custom/locations/#{uuid}"
    Ribbonex.Client.authd_get(path, params: params)
  end

  def search(params \\ []) do
    with {:ok, params} <- NimbleOptions.validate(Enum.into(params, []), @location_search_params) do
      path = "/v1/custom/locations"
      Ribbonex.Client.authd_get(path, params: params)
    end
  end
end
