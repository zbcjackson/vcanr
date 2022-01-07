require "fileutils"

After do |scenario|
  FileUtils.rm_rf @path
end
