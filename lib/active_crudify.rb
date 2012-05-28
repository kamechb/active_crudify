require 'active_support'
require 'i18n'
require 'responders'
require 'action_controller'
require 'active_crudify/class_methods'
require 'active_crudify/hook_methods'
require 'active_crudify/responder'

module ActiveCrudify
  class Engine < Rails::Engine
  end

  extend ActiveSupport::Concern

  included do
    include ActiveCrudify::HookMethods
  end

  def self.default_options(model_name)
    singular_name = model_name.to_s
    plural_name = singular_name.pluralize
    class_name = singular_name.camelize
    {
      :singular_name => singular_name,
      :plural_name => plural_name,
      :class_name => class_name,
      :paginate => true,
      :order_by => "created_at DESC",
      :conditions => {},
      :namespace => nil,
      :log => Rails.env == 'development'
    }
  end

end

ActionController::Base.send(:include, ActiveCrudify)


