module Vcanr
  class ChurnAnalyzer
    def initialize(repo_path)
      @stat = {}
      @repo = Rugged::Repository.new repo_path
      @reporter = ChurnReporter.new
    end

    def analyze
      walker = Rugged::Walker.new @repo
      walker.sorting(Rugged::SORT_TOPO | Rugged::SORT_REVERSE)
      walker.push(@repo.head.target_id)
      walker.each do |c|
        c.diff.deltas.each do |d|
          file = d.old_file[:path]
          case d.status
          when :deleted
            @stat.delete(file)
          else
            @stat[file] = if @stat.has_key?(file)
              @stat[file] + 1
            else
              1
            end
          end
        end
      end
    end

    def report
      @reporter.report @stat
    end
  end
end
