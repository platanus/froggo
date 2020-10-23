class FilterPullRequests < PowerTypes::Command.new(:all_pull_requests, :options)
  def perform
    filter(:project_name) { |pr| pr.by_repository(@options[:project_name]) }
    filter(:owner_name) { |pr| pr.by_owner(@options[:owner_name]) }
    filter(:title) { |pr| pr.by_title(@options[:title]) }
    filter(:start_date) { |pr| pr.by_start_date(@options[:start_date]) }
    filter(:end_date) { |pr| pr.by_end_date(@options[:end_date]) }
    filter(:top_liked) { |pr| pr.by_top_liked.limit(10) }
    pull_requests
  end

  private

  def pull_requests
    @pull_requests ||= @all_pull_requests
  end

  def filter(_option)
    @pull_requests = yield pull_requests if @options.key? _option
  end
end
