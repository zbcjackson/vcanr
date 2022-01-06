# frozen_string_literal: true

require_relative "vcanr/version"
require_relative "vcanr/vcanr_module"
require_relative "vcanr/application"
require_relative "vcanr/churn_analyzer"
require_relative "vcanr/churn_reporter"
require_relative "vcanr/git_repo_accessor"

module Vcanr
  class Error < StandardError; end
  # Your code goes here...
end
