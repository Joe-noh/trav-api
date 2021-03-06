defmodule Trav.PlanFactory do
  use ExMachina.Ecto, repo: Trav.Repo

  alias Trav.Plan

  def factory(:plan) do
    %Plan{
      body: """
      ## 1日目

      ### 美術館

      - 10:00 開館
      - 1時間くらいの予定

      ## 2日目

      ### 旅館

      ごろごろしてうたたね
      """
    }
  end

  def factory(:invalid_plan) do
    %Plan{body: 3}
  end
end
