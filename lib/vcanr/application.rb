require "optparse"
require "ostruct"

module Vcanr
  class Application
    def run(argv = ARGV)
      init argv
      @churn_analyzer.analyze
      @churn_analyzer.report
    end

    def init(argv)
      handle_options argv
      @churn_analyzer = ChurnAnalyzer.new(GitRepoAccessor.new(options.repo_path))
    end

    def handle_options(argv)
      set_default_options

      args = OptionParser.new do |opts|
        opts.banner = "vcanr [repository path]"
        opts.separator ""
        opts.separator "Options are ..."

        opts.on_tail("-h", "--help", "-H", "Display this help message.") do
          puts opts
          exit
        end

        standard_options.each { |args| opts.on(*args) }
      end.parse!(argv)
      options.repo_path = args[0] unless args.empty?
    rescue OptionParser::InvalidOption => ex
      warn ex.message
      exit(false)
    end

    def options
      @options ||= OpenStruct.new
    end

    def sort_options(options) # :nodoc:
      options.sort_by { |opt|
        opt.select { |o| o.is_a?(String) && o =~ /^-/ }.map(&:downcase).sort.reverse
      }
    end
    private :sort_options

    def standard_options
      sort_options([
        ["--churn", "-c", "Churn analytics", lambda { |value| options.churn = true }]
      ])
    end

    def set_default_options
      options.repo_path = "."
    end
  end
end
