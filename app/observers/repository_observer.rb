class RepositoryObserver < PowerTypes::Observer
  after_save :update_hook

  def update_hook
    if object.saved_change_to_tracked?
      if object.tracked
        HookService.new.subscribe(object)
      elsif !object.saved_change_to_id?
        HookService.new.unsubscribe(object)
      end
    end
  end
end
