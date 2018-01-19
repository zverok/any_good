require 'gems'
require 'octokit'
require 'pp'
require 'date'
require 'time_math'
require 'pastel'

class AnyGood
  attr_reader :name

  def initialize(name)
    @name = name
    @github_client =
      if (token = ENV['GITHUB_ACCESS_TOKEN'])
        Octokit::Client.new(access_token: token).tap { |client| client.user.login }
      else
        Octokit::Client.new
      end
  end

  GITHUB_URI_PATTERN = %r{^https?://(www\.)?github\.com/}

  def fetch
    data = {
      gem: Gems.info(name),
      gem_versions: Gems.versions(name),
      gem_rev_deps: Gems.reverse_dependencies(name)
    }

    repo_id = [data[:gem]['source_code_uri'], data[:gem]['homepage_uri']]
      .grep(GITHUB_URI_PATTERN).first&.sub(GITHUB_URI_PATTERN, '')

    if repo_id
      data.merge!(
        repo: @github_client.repository(repo_id).to_h,
        open_issues: @github_client.issues(repo_id, state: 'open', per_page: 50).map(&:to_h),
        closed_issues: @github_client.issues(repo_id, state: 'closed', per_page: 50).map(&:to_h),
        last_commit: @github_client.commits(repo_id, per_page: 1).first.to_h
        # open_prs: @github_client.issues(repo_id, state: 'open').map(&:to_h)
        # closed_prs: @github_client.issues(repo_id, state: 'closed').map(&:to_h)
      )
    end

    @data = OpenStruct.new(data)

    self
  end

  def report
    self.class.meters.each do |meter|
      puts meter.call(@data).format
    end
    self
  end

  require_relative 'any_good/meters'

  def self.meters
    @meters ||= []
  end

  def self.metric(name, thresholds: nil, &block)
    meters << Meter.new(name, thresholds, block)
  end

  T = TimeMath
  now = Time.now

  metric('Downloads', thresholds: [5_000, 10_000]) { data.gem['downloads'] }
  metric('Latest version', thresholds: [T.year.decrease(now), T.month.decrease(now, 2)]) {
    Time.parse(data.gem_versions.first['created_at'])
  }
  metric('Used by', thresholds: [10, 100]) { data.gem_rev_deps.count }

  metric('Stars', thresholds: [100, 500]) { data.repo[:stargazers_count] }
  metric('Forks', thresholds: [5, 20]) { data.repo[:forks_count] }
  metric('Last commit', thresholds: [T.month.decrease(now, 4), T.month.decrease(now)]) {
    data.last_commit.dig(:commit, :committer, :date)
  }

  metric('Open issues') {
    res = data.open_issues.count
    res == 50 ? '50+' : res
  }
  metric('...without reaction', thresholds: [-20, -4]) {
    data.open_issues.reject { |i| i[:labels].any? || i[:comments] > 0 }.count
  }
  metric('...last reaction', thresholds: [T.month.decrease(now), T.week.decrease(now)]) {
    data.open_issues.detect { |i| i[:labels].any? || i[:comments] > 0 }&.fetch(:updated_at)
  }
  metric('Closed issues') {
    res = data.closed_issues.count
    res == 50 ? '50+' : res
  }
  metric('...last closed') { data.closed_issues.first&.fetch(:closed_at) }
end
