defmodule Ribbonex.QueryTest do
  use ExUnit.Case

  describe "encode/1" do
    test "truth" do
      assert "specialty_ids=1" == Ribbonex.Query.encode(specialty_ids: "1")
      assert "specialty_ids=1" == Ribbonex.Query.encode(specialty_ids: ["1"])

      assert "specialty_ids=" <> URI.encode_www_form("1,2") ==
               Ribbonex.Query.encode(specialty_ids: ["1", "2"])
    end
  end
end
