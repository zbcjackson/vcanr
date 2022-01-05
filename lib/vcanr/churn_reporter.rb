require "formatador"

module Vcanr
  class ChurnReporter
    def report(stat)
      table = stat.sort_by { |file, count| count }.reverse.map { |pair| {file: pair[0], churn: pair[1]} }
      Formatador.display_table(table, [:file, :churn])
    end
  end
end
