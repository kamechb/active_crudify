class Admin::PostsController < ApplicationController
  crudify :post, :namespace => :admin, :only => [:index, :create]
end
