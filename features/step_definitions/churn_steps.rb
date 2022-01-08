Given("there is a repo with commits") do |table|
  table.hashes.each_with_index do |commit, index|
    (commit["Add"].split + commit["Modify"].split).each { |file| change_file(file) }
    commit["Delete"].split.each { |file| delete_file(file) }
    add_commit(index)
  end
end

When("churn analyze the repo") do
  @report = shell "exe/vcanr #{@path}"
end

Then("the report shows") do |table|
  result = @report.scan(/\|\s*(.*?)\s*\|\s*(\d+)\s*\|/)
  expect(result.size).to eq(table.hashes.size)
  table.hashes.each_with_index do |expected, index|
    expect(result[index][0]).to eq(expected["file"])
    expect(result[index][1]).to eq(expected["churn"])
  end
end
