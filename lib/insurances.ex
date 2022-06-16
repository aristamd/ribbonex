defmodule Ribbonex.Insurances do
  @moduledoc """
  This endpoint allows you to search through insurances that exist within the Ribbon API.

  [Ribbon Docs](https://ribbon.readme.io/docs/insurances-reference-endpoint)
  """

  def get_insurance(uuid, params \\ []) when is_binary(uuid) do
    path = "/v1/custom/insurances/#{uuid}"
    Ribbonex.Client.authd_get(path, params: params)
  end

  @insurances_search_params [
    page: [type: :non_neg_integer],
    search: [
      type: :string,
      doc: "Fuzzy search across all information within an insurance object."
    ],
    uuid: [
      type: :string,
      doc: "Ribbon unique identifier for the given insurance object."
    ],
    carrier_brand: [
      type: :string,
      doc: "Name of the payer brand (i.e. “BCBS”)."
    ],
    carrier_name: [
      type: :string,
      doc:
        "Name of the functional / operating payer for the given plan (i.e. “Blue Cross Blue Shield of Illinois”)."
    ],
    state: [
      type: :string,
      doc: "Two letter abbreviated state code."
    ],
    plan_name: [
      type: :string,
      doc: "Name of the plan (i.e. “BlueCare Direct”)."
    ],
    plan_type: [
      type: :string,
      doc: "Type of plan (i.e. PPO, HMO, POS)."
    ],
    display_name: [
      type: :string,
      doc: "Cleaned single value combining “carrier_name”, “plan_name”, and “plan_type”."
    ],
    category: [
      type: :string,
      doc:
        "Category or line of business of the insurance plan (i.e. Group, Medicare Advantage, Federal Exchange)."
    ]
  ]

  @doc """
  Search across the insurances endpoint.

  ```
  GET /v1/custom/insurances/
  ```

  Retrieves list of the type of appointment available in the practice.

  Ref: [https://docs.athenahealth.com/api/api-ref/appointment-types](https://docs.athenahealth.com/api/api-ref/appointment-types)

  ## Parameters:

  #{NimbleOptions.docs(@insurances_search_params)}

  ## Examples

      iex> Ribbonex.Insurances.search(search: "Aetna")
  """
  def search(params \\ []) do
    with {:ok, params} <- NimbleOptions.validate(Enum.into(params, []), @insurances_search_params) do
      path = "/v1/custom/insurances"
      Ribbonex.Client.authd_get(path, params: params)
    end
  end
end
