class FilterPullRequests < PowerTypes::Command.new(:all_pull_requests, :options)
  def perform
    filter(:project_name) { |pr| pr.by_repository(@options[:project_name]) }
    # filter(:owner) { |pr| pr.by_repository(@options[:project_name]) }
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
