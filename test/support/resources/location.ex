defmodule AshGraphql.Test.Location do
  @moduledoc false

  use Ash.Resource,
    domain: AshGraphql.Test.Domain,
    data_layer: Ash.DataLayer.Ets,
    extensions: [AshGraphql.Resource]

  graphql do
    type :location
  end

  attributes do
    uuid_primary_key(:id)

    attribute(:city, :string, public?: true)
  end

  actions do
    default_accept([:*])
    defaults([:create, :read, :update, :destroy])
  end
end
