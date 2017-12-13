class RepositoryObserver < PowerTypes::Observer
  after_save :update_hook
  def update_hook
    return nil if object.id_changed?
    @hook_service = HookService.new
    if object.tracked_changed? && object.tracked
      @hook_service.subscribe(object)
    elsif object.tracked_changed? && !object.tracked
      @hook_service.unsubscribe(object)
    end
  end
end
