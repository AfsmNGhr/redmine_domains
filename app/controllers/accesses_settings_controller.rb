class AccessesSettingsController < ApplicationController
  unloadable
  before_filter :find_project, :authorize

  def save
    if params[:accesses_settings] && params[:accesses_settings].is_a?(Hash) then
      settings = params[:accesses_settings]
      settings.map do |k, v|
        AccessesSetting[k, @project.id] = v
      end
    end
    redirect_to controller: 'projects', action: 'settings',
                id: @project, tab: params[:tab]
  end
end
