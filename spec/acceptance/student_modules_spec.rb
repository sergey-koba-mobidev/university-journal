require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Modules" do
  explanation "Modules for students to pass. Uses Authorization header to provide Bearer token. Allows to get module, answer questions, see results."
  before do
    DbSeedService.new.call
    header "Content-Type", "application/json"
    header "Authorization", "Bearer #{User.last.api_token}"
  end

  get "/api/v1/relationships/:relationship_id/modules/:id" do

    context "200" do
      let(:relationship_id) { Relationship.last.id }
      let(:id) { Visit.first.id }
      let(:raw_post) {params.to_json}

      example "Get module for student" do    
        do_request
        
        expected_response = {
          status: 0,
          response: Api::V1::StudentModule::Representer.new(StudentModule.last)
        }
        expect(status).to eq(200)
        expect(response_body).to eq(expected_response.to_json)
      end
    end
  end
  
end