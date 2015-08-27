class AccessesController < ApplicationController
  unloadable
  default_search_scope :accesses
  model_object Access
  before_filter :find_model_object, except: [ :index, :new, :create ]
  before_filter :find_project, only: :index

  after_filter only: [:create, :edit, :update] do |controller|
    if controller.request.post?
      controller.send :expire_action, controller: 'welcome', action: 'robots'
    end
  end

  def index
    @accesses = @project.accesses
  end

  def show
  end

  def new
    @access = Access.new
  end

  def edit
  end

  def create
    @access = Access.new(params[:access])
    respond_to do |format|
      if @access.save
        format.html { redirect_to @access,
                      notice: l(:notice_successful_create) }
        format.js { render action: :show, format: :js,
                           notice: l(:notice_successful_create) }
      else
        format.html { render action: :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @access.update_attributes(params[:access])
        format.html { redirect_to @access,
                      notice: l(:notice_successful_update) }
        format.js { render action: :show, format: :js,
                           notice: l(:notice_successful_update) }
      else
        format.html { render action: :edit }
        format.js
      end
    end
  end
end
