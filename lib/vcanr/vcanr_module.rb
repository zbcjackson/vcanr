require_relative "application"
module Vcanr
  class << self
    def application
      @application ||= Vcanr::Application.new
    end
  end
end
