defmodule AshGraphql.Test.OscarNomination do
  @moduledoc false

  use Ash.Resource,
    domain: AshGraphql.Test.Domain,
    data_layer: Ash.DataLayer.Ets,
    extensions: [AshGraphql.Resource]

  graphql do
    type(:oscar_nomination)
  end

  attributes do
    uuid_primary_key(:id)

    attribute(:title, :string, public?: true)
  end

  relationships do
    belongs_to(:movie, AshGraphql.Test.Movie, public?: true, writable?: true)
    belongs_to(:nomination_location, AshGraphql.Test.Location, public?: true, writable?: true)
    belongs_to(:celebration_location, AshGraphql.Test.Location, public?: true, writable?: true)
  end

  actions do
    default_accept([:*])
    defaults([:create, :read, :update, :destroy])
  end
end
