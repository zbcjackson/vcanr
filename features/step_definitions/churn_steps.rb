def shell(cmd)
  output = `#{cmd}`
  unless $?.success?
    p output
    raise "Shell error"
  end
  output
end

Given("there is a repo with commits") do |table|
  Dir.mkdir "./tmp" unless File.exist?("./tmp")
  dir = Dir.mktmpdir
  @path = "#{dir}/repo#{Time.now.to_i}"
  p @path
  Dir.mkdir @path
  Dir.chdir @path do
    shell "git init"
    table.hashes.each_with_index do |commit, index|
      (commit["Add"].split + commit["Modify"].split).each do |file|
        shell "echo 1 >> #{file}"
      end
      shell "git add ."
      shell "git commit -m 'commit #{index}'"
    end
  end
end

When("churn analyze the repo") do
  @report = shell "exe/vcanr #{@path}"
end

Then("the report shows") do |table|
  result = @report.scan(/\|\s*(.*?)\s*\|\s*(\d+)\s*\|/)
  table.hashes.each_with_index do |expected, index|
    expect(result[index][0]).to eq(expected["file"])
    expect(result[index][1]).to eq(expected["churn"])
  end
end
