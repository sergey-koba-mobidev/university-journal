require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Relationships" do
  explanation "Relationship between groups, disciplines and semesters. Uses Authorization header to provide Bearer token."
  before do
    DbSeedService.new.call
    header "Content-Type", "application/json"
    header "Authorization", "Bearer #{User.last.api_token}"
  end

  get "/api/v1/relationships/current" do

    context "200" do
      let(:raw_post) {params.to_json}

      example "Get Current Relationships for user" do    
        do_request

        expected_response = {
          status: 0,
          response: Api::V1::Relationship::Representer.for_collection.new(Relationship.all)
        }
        expect(status).to eq(200)
        expect(response_body).to eq(expected_response.to_json)
      end
    end
  end
end