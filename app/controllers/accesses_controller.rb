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
    respond_to do |format|
      format.html
      format.js { render template: 'ajax/action' }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.js { render template: 'ajax/action' }
    end
  end

  def new
    @access = Access.new
    respond_to do |format|
      format.html
      format.js { render template: 'ajax/action' }
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js { render template: 'ajax/action' }
    end
  end

  def create
    @access = Access.new(params[:access])
    respond_to do |format|
      if @access.save
        format.html { redirect_to (params[:continue] ? { action: :new } : @access),
                                  notice: l(:notice_successful_create) }
        format.js { redirect_to (params[:continue] ? { action: :new } : { action: :show } ),
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
        format.js { redirect_to action: :show,
                           notice: l(:notice_successful_update) }
      else
        format.html { render action: :edit }
        format.js
      end
    end
  end
end
