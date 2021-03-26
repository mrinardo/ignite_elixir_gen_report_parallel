# GenReportParallel

This module generates a report of worked hours based on the lines of CSV files that are processed in pararallel and merged together in the end.

The CSV files have the following structure:

|name|worked hours|day |month|year|
|----|-----------:|---:|----:|---:|
|Daniele|7|29|4|2018|
|Mayk|4|9|12|2019|
|Daniele|5|27|12|2016|
|Mayk|1|2|12|2017|
|Giuliano|3|13|2|2017|
|Cleiton|1|22|6|2020|
|Giuliano|6|18|2|2019|

This is [challenge #2](https://www.notion.so/Desafio-02-Gerando-relat-rios-com-paralelismo-0c75f6deada5441285fb434406559aa4) of Rocketseat's Ignite Elixir module 2.

## Usage

Once inside the project's directory, you can run it using Elixir's interactive shell:

```shell
$ iex -S mix
```

```elixir
iex(1)> GenReportParallel.build(["part_1.csv","part_2.csv","part_3.csv"])
  {:ok,
    %{
      "all_hours" => %{
        "cleiton" => 13797,
        "daniele" => 13264,
        "danilo" => 13583,
        "diego" => 13015,
        "giuliano" => 13671,
        "jakeliny" => 13909,
        "joseph" => 13174,
        "mayk" => 13526,
        "rafael" => 13597,
        "vinicius" => 13412
      },
    ...
```

## Tests

You can also run the tests script in the terminal (outside `iex`):

```shell
$ mix test
```
