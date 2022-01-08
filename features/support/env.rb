require "fileutils"

Before do
  init_repo
end

After do |scenario|
  FileUtils.rm_rf @path
end
