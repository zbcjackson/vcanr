module Vcanr
  describe "Vcanr::GitRepoAccessor" do
    before do
      init_repo
    end

    after do
      delete_repo
    end

    context "when repo is empty" do
      it "commits should be empty" do
        repo = GitRepoAccessor.new @path
        expect(repo.commits).to be_empty
      end
    end
  end
end
