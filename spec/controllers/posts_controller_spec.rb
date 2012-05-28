require File.expand_path('../../spec_helper', __FILE__)

describe PostsController do
  let!(:post_params) { {'name' => 'test', 'content' => 'testcontent'} }
  let!(:post_obj){ Post.create!(post_params) }
  
  describe "GET index" do
    it "should assigns instance" do
      get :index
      assigns[:crud_options].should_not be_nil
      assigns[:posts].should_not be_nil
    end
    it "should render template index" do
      get :index
      response.should render_template('index')
    end
  end

  describe "GET show" do
    before do
      Post.stub(:find).and_return post_obj
    end
    it "should assigns post" do
      get :show
      assigns[:post].should == post_obj
    end
    it "shoule render show template" do
      get :show
      response.should render_template('show')
    end
  end

  describe "GET new" do
    it "should assigns post" do
      get :new
      assigns[:post].should_not be_nil
    end
    it "should render new template" do
      get :new
      response.should render_template("new")
    end
  end

  describe "POST create" do
    context "before_create hook return true" do
      it "should redirect to show action with html format" do
        post :create, :post => post_params
        response.should redirect_to(post_path(assigns[:post]))
      end
      it "should render post json data with json format" do
        post :create, :post => post_params, :format => 'json'
        response.content_type.should == "application/json"
      end
      it "should render post xml data with xml format" do
        post :create, :post => post_params, :format => 'xml'
        response.content_type.should == 'application/xml'
      end
    end
    context "before_create hook return false" do
      before do
        controller.class_eval do
          def before_create
            false
          end
        end
      end
      it "should interrupt the action and render raise template missing" do
        expect { post :create, :post => post_params }.should raise_error
      end
    end
    
  end

  describe "PUT update" do
    let!(:post_params) { {'name' => 'update name', 'content' => 'update content'} }
    
    context "before_update hook return true" do
      it "should redirect to show with html format" do
        put :update, :id => post_obj.id, :post => post_params
        response.should redirect_to(post_path(assigns[:post]))
      end
      it "should render json data with json format" do
        put :update, :id => post_obj.id, :post => post_params, :format => 'json'
        response.content_type.should == 'application/json'
      end
      it "should render xml data with xml format" do
        put :update, :id => post_obj.id, :post => post_params, :format => 'xml'
        response.content_type.should == 'application/xml'
      end
      it "should set flash notice" do
        put :update, :id => post_obj.id, :post => post_params
        flash[:notice].should_not be_blank
        flash[:notice].should == I18n.t("flash.actions.update.notice", :resource_name => 'Post')
      end
    end
    context "before_update hook return false" do
      before do
        controller.class_eval do
          def before_update; false; end
        end
      end
      it "should interrupt action and render template misssing" do
        lambda { put :update, :id => post_obj.id, :post => post_params }.should raise_error
      end
    end
  end

  describe "DELETE destroy" do
    before do
      Post.stub!(:find).and_return post_obj
    end
    it "should redirect to index action with html format" do
      delete :destroy, :id => post_obj.id
      response.should redirect_to(posts_path)
    end
    it "should head ok with json, xml format" do
      delete :destroy, :id => post_obj.id, :format => 'json'
      response.body.should be_blank
    end
    it "shoul head ok with xml format" do
      delete :destroy, :id => post_obj.id, :format => 'xml'
      response.body.should be_blank
    end
  end
  
end
