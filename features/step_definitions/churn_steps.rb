Given("there is a repo with commits") do |table|
  Dir.mkdir "./tmp" unless File.exist?("./tmp")
  dir = Dir.mktmpdir
  @path = "#{dir}/repo#{Time.now.to_i}"
  p @path
  Dir.mkdir @path
  Dir.chdir @path do
    `git init`
    table.hashes.each_with_index do |commit, index|
      (commit["Add"].split + commit["Modify"].split).each do |file|
        `echo 1 >> #{file}`
      end
      `git add .`
      `git commit -m "commit #{index}"`
    end
  end
end

When("churn analyze the repo") do
  @report = `exe/vcanr #{@path}`
end

Then("the report shows") do |table|
  @report.scan(/\|\s*(.*?)\s*\|\s*(\d+)\s*\|/).each_with_index do |match, index|
    expect(match[0]).to eq(table.hashes[index]["file"])
    expect(match[1]).to eq(table.hashes[index]["churn"])
  end
end
