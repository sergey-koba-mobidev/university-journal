require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Discipline Modules" do
  explanation "Modules for disciplines. Uses Authorization header to provide Bearer token. Only admins and Teachers can access"
  before do
    DbSeedService.new.call
    header "Content-Type", "application/json"
    header "Authorization", "Bearer #{User.first.api_token}"
  end

  get "/api/v1/disciplines/:discipline_id/modules" do

    context "200" do
      let(:discipline_id) { Discipline.last.id }
      let(:raw_post) {params.to_json}

      example "Get modules for discipline" do    
        do_request

        expected_response = {
          status: 0,
          response: Api::V1::DisciplineModule::Representer.for_collection.new(DisciplineModule.all)
        }
        expect(status).to eq(200)
        expect(response_body).to eq(expected_response.to_json)
      end
    end
  end
  
end