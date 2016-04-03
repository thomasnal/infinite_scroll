require 'rails_helper'
require 'support/api_schema_matcher'

RSpec.describe FeedsController, type: :controller do
  fixtures :all
  render_views

  describe 'GET #index' do
    it 'must GET index successfully' do
      get :index, format: :json, id: users(:joe).id
      expect(response).to have_http_status(:success)
      expect(response).to match_response_schema('feeds')
    end
  end

  describe 'routes' do
    it 'routes to user feeds' do
      expect(get: "/users/#{users(:joe).id}/feeds").to route_to(
        controller: 'feeds', action: 'index', id: users(:joe).id.to_s)
    end
  end
end
