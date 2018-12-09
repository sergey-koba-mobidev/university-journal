require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Disciplines" do
  explanation "Disciplines. Uses Authorization header to provide Bearer token. Only admins and Teachers can access"
  before do
    DbSeedService.new.call
    header "Content-Type", "application/json"
    header "Authorization", "Bearer #{User.first.api_token}"
  end

  get "/api/v1/disciplines" do

    context "200" do
      let(:raw_post) {params.to_json}

      example "Get all disciplines" do    
        do_request

        expected_response = {
          status: 0,
          response: Api::V1::Discipline::Representer.for_collection.new(Discipline.all)
        }
        expect(status).to eq(200)
        expect(response_body).to eq(expected_response.to_json)
      end
    end
  end
end