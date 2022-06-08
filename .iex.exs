Application.put_env(:ribbonex, :token, System.fetch_env!("RIBBON_API_TOKEN"))

children = [
  {Ribbonex.Client, []}
]

opts = [strategy: :one_for_one, name: RibbonexDev.Supervisor]
Supervisor.start_link(children, opts)


#
# Helpers
#

defmodule ReplHelpers do
  def search(term) do
    with {:ok, %{data: %{"results" => results}}} when length(results) > 0 <- Ribbonex.search_insurances(search: term) do
      results
      |> Enum.sort_by(& &1["confidence"])
      |> Enum.reverse()
      |> Enum.map(& &1["carrier_name"])
      |> Enum.uniq()
    end
  end

  def carrier_name(name) do
    with {:ok, %{data: %{"count" => count}}} when is_integer(count) <- Ribbonex.search_insurances(carrier_name: name) do
      count
    end
  end
end
