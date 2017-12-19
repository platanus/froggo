class HookObserver < PowerTypes::Observer
  before_destroy :destroy_api_hook

  def destroy_api_hook
    HookService.new.destroy_api_hook(object)
  end
end
