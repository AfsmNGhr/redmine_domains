class DomainsController < ApplicationController
  unloadable
  default_search_scope :domains
  model_object Domain
  before_filter :find_model_object,
                except: [ :index, :new, :create, :context_menu ]

  after_filter only: [:create, :edit, :update] do |controller|
    if controller.request.post?
      controller.send :expire_action, controller: 'welcome', action: 'robots'
    end
  end

  helper :custom_fields

  def index
    @domains = Domain.table(params)
    @custom_fields = DomainCustomField.all
    respond_to do |format|
      format.html
      format.js { render template: 'ajax/action' }
    end
  end

  def show
    @accesses = @domain.accesses
    respond_to do |format|
      format.html
      format.js { render template: 'ajax/action' }
    end
  end

  def new
    @domain = Domain.new
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
    @domain = Domain.new(params[:domain])
    respond_to do |format|
      if @domain.save
        format.html { redirect_to (params[:continue] ? { action: :new } : @domain),
                                  notice: l(:notice_successful_create) }
        format.js { redirect_to (params[:continue] ? { action: :new } : { action: :show }),
                            notice: l(:notice_successful_create) }
      else
        format.html { render action: :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @domain.update_attributes(params[:domain])
        format.html { redirect_to @domain,
                      notice: l(:notice_successful_update) }
        format.js { redirect_to action: :show,
                           notice: l(:notice_successful_update) }
      else
        format.html { render action: :edit }
        format.js
      end
    end
  end

  def context_menu
    @domains = Domain.visible.where(id: params[:selected_domains])
    @domain = @domains.first if @domains.size == 1
    render layout: false
  end

  def hide_or_show
    @domain.update_attribute :hidden, (@domain.hidden? ? false : true)
    redirect_to domains_path
  end
end
