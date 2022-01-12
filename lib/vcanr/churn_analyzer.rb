module Vcanr
  class ChurnAnalyzer
    def initialize(repo_accessor, reporter = ChurnReporter.new)
      @stat = {}
      @repo_accessor = repo_accessor
      @reporter = reporter
    end

    def analyze
      @repo_accessor.commits.each do |c|
        c.deltas.each do |d|
          case d.status
          when :deleted
            @stat.delete(d.old_file)
          else
            @stat[d.old_file] = @stat.has_key?(d.old_file) ? @stat[d.old_file] + 1 : 1
          end
        end
      end
    end

    def report
      @reporter.report @stat
    end
  end
end
