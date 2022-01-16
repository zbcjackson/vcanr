module Vcanr
  def commit_with(*deltas)
    commit = Commit.new
    deltas.each do |d|
      delta = Delta.new
      delta.old_file = d.is_a?(Hash) ? d[:old_file] : d
      delta.new_file = d.is_a?(Hash) ? d[:new_file] : d
      delta.status = d.is_a?(Hash) ? d[:status] : :modified
      delta.lines = d.is_a?(Hash) ? d[:lines] : 0
      commit.deltas << delta
    end
    commit
  end

  describe "Vcanr::ChurnAnalyzer" do
    before do
      @repo_accessor = instance_double(GitRepoAccessor)
      @reporter = instance_spy(ChurnReporter)
      @churn_analyzer = ChurnAnalyzer.new @repo_accessor, @reporter
    end

    it "show empty stat when no commits" do
      allow(@repo_accessor).to receive(:commits) { [] }
      @churn_analyzer.analyze
      @churn_analyzer.report
      expect(@reporter).to have_received(:report).with({})
    end

    it "count file changes" do
      allow(@repo_accessor).to receive(:commits) { [commit_with("a.txt", "b.txt"), commit_with("a.txt")] }
      @churn_analyzer.analyze
      @churn_analyzer.report
      expect(@reporter).to have_received(:report).with({"a.txt" => 2, "b.txt" => 1})
    end

    it "remove file stat when file change is deleted" do
      allow(@repo_accessor).to receive(:commits) { [commit_with("a.txt", "b.txt"), commit_with({old_file: "a.txt", status: :deleted})] }
      @churn_analyzer.analyze
      @churn_analyzer.report
      expect(@reporter).to have_received(:report).with({"b.txt" => 1})
    end

    it "replace file stat when file change is renamed" do
      allow(@repo_accessor).to receive(:commits) { [commit_with("a.txt", "b.txt"), commit_with("a.txt"), commit_with({old_file: "a.txt", new_file: "c/c.txt", status: :renamed, lines: 0})] }
      @churn_analyzer.analyze
      @churn_analyzer.report
      expect(@reporter).to have_received(:report).with({"b.txt" => 1, "c/c.txt" => 2})
    end

    it "replace file stat when file change is renamed and changed" do
      allow(@repo_accessor).to receive(:commits) { [commit_with("a.txt", "b.txt"), commit_with("a.txt"), commit_with({old_file: "a.txt", new_file: "c/c.txt", status: :renamed, lines: 1})] }
      @churn_analyzer.analyze
      @churn_analyzer.report
      expect(@reporter).to have_received(:report).with({"b.txt" => 1, "c/c.txt" => 3})
    end
  end
end
