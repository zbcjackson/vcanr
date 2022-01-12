require "rugged"

module Vcanr
  class GitRepoAccessor
    def initialize(repo_path)
      @repo = Rugged::Repository.new repo_path
    end

    def commits
      commits_history = []
      return commits_history if @repo.empty?
      walker = Rugged::Walker.new @repo
      walker.sorting(Rugged::SORT_TOPO | Rugged::SORT_REVERSE)
      walker.push(@repo.head.target_id)
      walker.each do |c|
        commit = Commit.new
        commit.id = c.tree_id
        commit.message = c.message
        commit.time = Time.at(c.epoch_time)
        commit.committer = c.committer
        diff = c.diff
        diff.find_similar! all: true
        diff.each_delta do |d|
          delta = Delta.new
          delta.old_file = d.old_file[:path]
          delta.new_file = d.new_file[:path]
          delta.status = d.status
          commit.deltas << delta
        end
        commits_history << commit
      end
      commits_history
    end
  end

  class Commit
    attr_accessor :id, :message, :time, :committer
    attr_reader :deltas

    def initialize
      @deltas = []
    end
  end

  class Delta
    attr_accessor :old_file, :new_file, :status
  end
end
