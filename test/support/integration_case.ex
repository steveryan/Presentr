defmodule PresentrWeb.IntegrationCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use PresentrWeb.ConnCase
      use PhoenixIntegration
    end
  end
end
