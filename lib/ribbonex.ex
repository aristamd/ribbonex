defmodule Ribbonex do
  defdelegate search_providers(params \\ []),
    to: Ribbonex.Providers,
    as: :search

  defdelegate get_provider(npi, params \\ []),
    to: Ribbonex.Providers

  defdelegate search_specialties(params \\ []),
    to: Ribbonex.Specialties,
    as: :search

  defdelegate get_insurance(uuid, params \\ []),
    to: Ribbonex.Insurances

  defdelegate search_insurances(params \\ []),
    to: Ribbonex.Insurances,
    as: :search
end
