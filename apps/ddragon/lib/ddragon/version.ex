defmodule Ddragon.Version do
    defstruct [:major, :minor, :patch, :revision]

    @type t :: %__MODULE__{
      major: integer(),
      minor: integer(),
      patch: integer(),
      revision: integer() | nil
    }

    def version_string(version) do
      if version.revision do
        "#{version.major}.#{version.minor}.#{version.patch}.#{version.revision}"
      else
        "#{version.major}.#{version.minor}.#{version.patch}"
      end
    end

    def parse(json) do
      parts = String.split(json, ".")
        |> Enum.map(fn s ->
          {res, ""} = Integer.parse(s)
          res
        end)
      case parts do
        [major, minor, patch, revision] -> %__MODULE__{
            major: major,
            minor: minor,
            patch: patch,
            revision: revision
          }
        [major, minor, patch] -> %__MODULE__{
            major: major,
            minor: minor,
            patch: patch,
            revision: nil
          }
      end
    end
end
