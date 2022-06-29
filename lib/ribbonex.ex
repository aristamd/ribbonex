defmodule Ribbonex do
  #
  # Providers
  #

  defdelegate search_providers(params \\ []),
    to: Ribbonex.Providers,
    as: :search

  defdelegate get_provider(npi, params \\ []),
    to: Ribbonex.Providers

  #
  # Specialties
  #

  defdelegate search_specialties(params \\ []),
    to: Ribbonex.Specialties,
    as: :search

  #
  # Insurance
  #

  defdelegate get_insurance(uuid, params \\ []),
    to: Ribbonex.Insurances

  defdelegate search_insurances(params \\ []),
    to: Ribbonex.Insurances,
    as: :search

  #
  # Locations
  #

  defdelegate search_locations(params \\ []),
    to: Ribbonex.Locations,
    as: :search

  defdelegate get_location(uuid, params \\ []), to: Ribbonex.Locations
end
