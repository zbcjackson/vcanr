def shell(cmd)
  output = `#{cmd}`
  unless $?.success?
    p output
    raise "Shell error"
  end
  output
end

def change_file(file)
  shell "echo 1 >> #{@path}/#{file}"
end

def delete_file(file)
  shell "rm #{@path}/#{file}"
end
