defmodule Ribbonex.Specialties do
  @moduledoc """
  This endpoint allows you to search through provider specialties that exist within the Ribbon API.

  If you are leveraging a Custom Provider Index, then you can also use this endpoint to create and edit your own specialties.

  ### Endpoints:
  - Standard Index: /v1/specialties/ and /v1/specialties/{UUID}
  - Custom Index: /v1/custom/specialties/ and /v1/custom/specialties/{UUID}

  ### Example use-case:
  You want your users to be able to select from a drop down list of available provider specialties (i.e. Cardiology), which you power through GET requests to this endpoint.

  ### Reference
  [Ribbon Docs](https://ribbon.readme.io/docs/specialties-reference-endpoint)
  """

  @specialties_search_params [
    page: [type: :non_neg_integer],
    search: [
      type: :string,
      doc: "String input for fuzzy matching specialties"
    ]
  ]

  def search(params) do
    with {:ok, params} <-
           NimbleOptions.validate(Enum.into(params, []), @specialties_search_params) do
      path = "/v1/custom/specialties"
      Ribbonex.Client.authd_get(path, params: params)
    end
  end
end
