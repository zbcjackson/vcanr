module Vcanr
  class ChurnReporter
    def report(stat)
      summary = []
      stat.sort_by { |file, count| count }.reverse.each { |pair| summary << "%s \t %d" % pair}
      summary.join("\n")
    end
  end
end
