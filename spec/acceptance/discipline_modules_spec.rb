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

  post "/api/v1/disciplines/:discipline_id/modules" do
    with_options with_example: true do
      parameter :title, 'Html & Css', required: true
      parameter :duration, 3600, required: true
    end

    context "200" do
      let(:discipline_id) { Discipline.last.id }
      let(:raw_post) {params.to_json}

      example "Create module for discipline" do
        request = {
          title: 'Html & Css',
          duration: 3600
        }  
        do_request(request)
        
        expected_response = {
          status: 0,
          response: Api::V1::DisciplineModule::Representer.new(DisciplineModule.last)
        }
        expect(status).to eq(200)
        expect(response_body).to eq(expected_response.to_json)
      end
    end

    context "400" do
      let(:discipline_id) { Discipline.last.id }
      let(:raw_post) {params.to_json}

      example "Error creating module for discipline" do
        request = {
          title: 'Html & Css'
        }  
        do_request(request)
        
        expected_response = {
          status: 1,
          error: "duration, is not a number, can't be blank"
        }
        expect(status).to eq(400)
        expect(response_body).to eq(expected_response.to_json)
      end
    end
  end

  post "/api/v1/disciplines/:discipline_id/modules/:id" do
    with_options with_example: true do
      parameter :title, 'Html & Css', required: true
      parameter :duration, 3600, required: true
    end

    context "200" do
      let(:discipline_id) { Discipline.last.id }
      let(:id) { DisciplineModule.last.id }
      let(:raw_post) {params.to_json}

      example "Update module for discipline" do
        request = {
          title: 'Html & Css2',
          duration: 3600
        }  
        do_request(request)

        expect(status).to eq(200)
        expect(response_body).to include("Css2")
      end
    end
  end

  delete "/api/v1/disciplines/:discipline_id/modules/:id" do
    context "200" do
      let(:discipline_id) { Discipline.last.id }
      let(:id) { DisciplineModule.last.id }
      let(:raw_post) {params.to_json}

      example "Delete module for discipline" do
        do_request

        expect(status).to eq(200)
        expect(DisciplineModule.count).to eq(0)
      end
    end
  end

end