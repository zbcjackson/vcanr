module Vcanr
  describe "Vcanr::GitRepoAccessor" do
    before do
      init_repo
      @repo = GitRepoAccessor.new @path
    end

    after do
      delete_repo
    end

    context "when repo is empty" do
      it "commits should be empty" do
        expect(@repo.commits).to be_empty
      end
    end

    context "when repo has commits" do
      before do
        change_file("a.txt")
        change_file("b.txt")
        change_file("c.txt")
        add_commit(1)
        change_file("a.txt")
        add_commit(2)
        delete_file("b.txt")
        add_commit(3)
        move_file("c.txt", "d.txt")
        add_commit(4)
        add_dir("d")
        move_file("d.txt", "d/d.txt")
        add_commit(5)
      end
      it "commits contains added changes" do
        expect(@repo.commits[0].message).to eq("commit 1\n")
        expect(@repo.commits[0].deltas.size).to eq(3)
        expect(@repo.commits[0].deltas[0]).to have_attributes(old_file: "a.txt", new_file: "a.txt", status: :added)
        expect(@repo.commits[0].deltas[1]).to have_attributes(old_file: "b.txt", new_file: "b.txt", status: :added)
        expect(@repo.commits[0].deltas[2]).to have_attributes(old_file: "c.txt", new_file: "c.txt", status: :added)
      end
      it "commits contains modified changes" do
        expect(@repo.commits[1].message).to eq("commit 2\n")
        expect(@repo.commits[1].deltas.size).to eq(1)
        expect(@repo.commits[1].deltas[0]).to have_attributes(old_file: "a.txt", new_file: "a.txt", status: :modified)
      end
      it "commits contains deleted changes" do
        expect(@repo.commits[2].message).to eq("commit 3\n")
        expect(@repo.commits[2].deltas.size).to eq(1)
        expect(@repo.commits[2].deltas[0]).to have_attributes(old_file: "b.txt", new_file: "b.txt", status: :deleted)
      end
      it "commits contains renamed changes" do
        expect(@repo.commits[3].message).to eq("commit 4\n")
        expect(@repo.commits[3].deltas.size).to eq(1)
        expect(@repo.commits[3].deltas[0]).to have_attributes(old_file: "c.txt", new_file: "d.txt", status: :renamed)
      end
      it "commits contains moved changes" do
        expect(@repo.commits[4].message).to eq("commit 5\n")
        expect(@repo.commits[4].deltas.size).to eq(1)
        expect(@repo.commits[4].deltas[0]).to have_attributes(old_file: "d.txt", new_file: "d/d.txt", status: :renamed)
      end
    end
  end
end
