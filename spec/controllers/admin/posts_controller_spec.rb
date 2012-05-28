require File.expand_path('../../../spec_helper', __FILE__)

describe Admin::PostsController do
  describe "GET index" do
    it "should render template admin/posts/index" do
      get :index
      response.should render_template('admin/posts/index')
    end
  end

  describe "POST create" do
    let!(:post_params) { {'name' => 'test', 'content' => 'testcontent'} }
    let!(:post_obj) { mock_model(Post, post_params) }
                                 
    before do
      post_obj.stub!(:save).and_return true
      Post.stub!(:new).and_return post_obj
    end
    it "should redirect to admin post show with html" do
      post :create, :post => post_params
      response.should redirect_to(admin_post_path(post_obj))
    end
  end

  describe "undefined actions" do
    it "get new, edit should raise error for not exist action" do
      expect { get :new }.should raise_error
      expect { get :edit }.should raise_error
    end
  end

end

