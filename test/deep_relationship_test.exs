defmodule AshGraphql.DeepRelationShipTest do
  use ExUnit.Case, async: false

  require Ash.Query

  setup do
    on_exit(fn ->
      AshGraphql.TestHelpers.stop_ets()
    end)
  end

  test "can resolve through has_one into a belongs_to" do
    movie =
      AshGraphql.Test.Movie
      |> Ash.Changeset.for_create(:create, title: "The Bee movie")
      |> Ash.create!()

    nomination_location =
      AshGraphql.Test.Location
      |> Ash.Changeset.for_create(:create, city: "Tokyo")
      |> Ash.create!()

    celebration_location =
      AshGraphql.Test.Location
      |> Ash.Changeset.for_create(:create, city: "Hamar")
      |> Ash.create!()

    nomination =
      AshGraphql.Test.OscarNomination
      |> Ash.Changeset.for_create(:create,
        title: "Best supporting actor: Zach Daniel",
        nomination_location_id: nomination_location.id,
        celebration_location_id: celebration_location.id,
        movie_id: movie.id
      )
      |> Ash.create!()

    document =
      """
      query Movies($id: ID!) {
        getMovie(id: $id) {
          title
          oscarNomination {
            id
            nominationLocation {
              id
              city
            }
            celebrationLocation {
              id
              city
            }
          }
        }
      }
      """

    resp = Absinthe.run(document, AshGraphql.Test.Schema, variables: %{"id" => movie.id})
    assert {:ok, result} = resp
    refute Map.has_key?(result, :errors)
    IO.inspect(result)
  end

  test "can resolve through has_one into a nil belongs_to" do
    movie =
      AshGraphql.Test.Movie
      |> Ash.Changeset.for_create(:create, title: "Vaiana")
      |> Ash.create!()

    nomination =
      AshGraphql.Test.OscarNomination
      |> Ash.Changeset.for_create(:create,
        title: "Best lead actor: Zach Daniel",
        movie_id: movie.id
      )
      |> Ash.create!()

    document =
      """
      query Movies($id: ID!) {
        getMovie(id: $id) {
          title
          oscarNomination {
            id
            nominationLocation {
              id
              city
            }
            celebrationLocation {
              id
              city
            }
          }
        }
      }
      """

    resp = Absinthe.run(document, AshGraphql.Test.Schema, variables: %{"id" => movie.id})
    assert {:ok, result} = resp
    refute Map.has_key?(result, :errors)
    IO.inspect(result)
  end
end
