def shell(cmd)
  output = `#{cmd}`
  unless $?.success?
    p output
    raise "Shell error"
  end
  output
end

def add_dir(dir)
  Dir.mkdir("#{@path}/#{dir}")
end

def change_file(file)
  shell "echo 1 >> #{@path}/#{file}"
end

def move_file(file, to)
  shell "mv #{@path}/#{file} #{@path}/#{to}"
end

def delete_file(file)
  shell "rm #{@path}/#{file}"
end
