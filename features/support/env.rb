require_relative "../../spec/shell/shell"
require_relative "../../spec/shell/git"

Before do
  init_repo
end

After do |scenario|
  delete_repo
end
