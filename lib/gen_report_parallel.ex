defmodule GenReportParallel do
  alias GenReportParallel.Parser

  @people [
    "daniele",
    "mayk",
    "giuliano",
    "cleiton",
    "jakeliny",
    "joseph",
    "diego",
    "danilo",
    "rafael",
    "vinicius"
  ]

  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  def build(filenames) when not is_list(filenames) do
    {:error, "Please provide a list of source files for the report"}
  end

  def build(filenames) do
    result =
      filenames
      |> Task.async_stream(&build_single_report/1)
      |> Enum.reduce(report_acc(), fn {:ok, single_report}, acc ->
        merge_reports(acc, single_report)
      end)

    {:ok, result}
  end

  def build_single_report(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.to_list()
    |> Enum.reduce(report_acc(), fn line, acc -> sum_lines(line, acc) end)
  end

  defp report_acc() do
    all_hours = all_hours_structure()
    hours_per_month = hours_per_month_structure()
    hours_per_year = hours_per_year_structure()

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp sum_lines([name, hours, _day, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => hours_per_month,
         "hours_per_year" => hours_per_year
       }) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    month_name = Enum.at(@months, month - 1)

    hours_per_month =
      put_in(hours_per_month[name][month_name], hours_per_month[name][month_name] + hours)

    hours_per_year = put_in(hours_per_year[name][year], hours_per_year[name][year] + hours)

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp merge_reports(acc, single_report) do
    %{
      "all_hours" => all_hours1,
      "hours_per_month" => hours_per_month1,
      "hours_per_year" => hours_per_year1
    } = acc

    %{
      "all_hours" => all_hours2,
      "hours_per_month" => hours_per_month2,
      "hours_per_year" => hours_per_year2
    } = single_report

    all_hours = merge_maps_values(all_hours1, all_hours2)
    hours_per_month = merge_maps(hours_per_month1, hours_per_month2)
    hours_per_year = merge_maps(hours_per_year1, hours_per_year2)

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp merge_maps_values(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 -> value1 + value2 end)
  end

  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, fn _key, submap1, submap2 -> merge_maps_values(submap1, submap2) end)
  end

  defp all_hours_structure, do: Enum.into(@people, %{}, &{&1, 0})

  defp hours_per_month_structure do
    months = Enum.into(@months, %{}, &{&1, 0})
    Enum.into(@people, %{}, &{&1, months})
  end

  defp hours_per_year_structure do
    years = Enum.into(2016..2020, %{}, &{&1, 0})
    Enum.into(@people, %{}, &{&1, years})
  end

  defp build_report(all_hours, hours_per_month, hours_per_year) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end
end
