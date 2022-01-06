require "rspec"

module Vcanr
  describe "Vcanr::ChurnAnalyzer" do
    before do
      @repo_accessor = instance_double(GitRepoAccessor)
      @reporter = instance_spy(ChurnReporter)
      @churn_analyzer = ChurnAnalyzer.new @repo_accessor, @reporter
    end

    context "no commits" do
      it "returns empty stat" do
        allow(@repo_accessor).to receive(:commits) { [] }
        @churn_analyzer.analyze
        @churn_analyzer.report
        expect(@reporter).to have_received(:report).with({})
      end
    end
  end
end
