require 'rails_helper'
require 'support/api_schema_matcher'

RSpec.describe FeedsController, type: :controller do
  fixtures :all
  render_views

  describe "GET #index" do
    it "must GET index successfully" do
      get :index, format: :json, id: users(:joe).id
      expect(response).to have_http_status(:success)
      expect(response).to match_response_schema('feeds')
    end
  end
end
