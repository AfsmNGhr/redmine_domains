class DomainsController < ApplicationController
  unloadable
  default_search_scope :domains
  model_object Domain
  before_filter :find_model_object, :except => [:index, :new, :create]

  after_filter :only => [:create, :edit, :update] do |controller|
    if controller.request.post?
      controller.send :expire_action, :controller => 'welcome', :action => 'robots'
    end
  end

  helper :custom_fields

  def index
    @domains = Domain.table(params)
    @custom_fields = DomainCustomField.all
  end

  def show
  end

  def new
    @domain = Domain.new
  end

  def edit
  end

  def create
    @domain = Domain.new(params[:domain])
    if @domain.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to(@domain)
    else
      render action: :new
    end
  end

  def update
    if @domain.update_attributes(params[:domain])
      flash[:notice] = l(:notice_successful_update)
      redirect_to(@domain)
    else
      render action: :edit
    end
  end

  def hide_or_show
    @domain.update_attribute :hidden, (@domain.hidden? ? false : true)
    redirect_to domains_path
  end
end
