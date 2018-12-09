require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Question Groups" do
  explanation "Question Groups for disciplines modules. Uses Authorization header to provide Bearer token. Only admins and Teachers can access"
  before do
    DbSeedService.new.call
    header "Content-Type", "application/json"
    header "Authorization", "Bearer #{User.first.api_token}"
  end

  get "/api/v1/modules/:discipline_module_id/question_groups" do

    context "200" do
      let(:discipline_module_id) { DisciplineModule.last.id }
      let(:raw_post) {params.to_json}

      example "Get question groups for discipline modules" do
        do_request

        expected_response = {
          status: 0,
          response: Api::V1::QuestionGroup::Representer.for_collection.new(QuestionGroup.all)
        }
        expect(status).to eq(200)
        expect(response_body).to eq(expected_response.to_json)
      end
    end
  end

  post "/api/v1/modules/:discipline_module_id/question_groups" do
    with_options with_example: true do
      parameter :title, 'Html', required: true
      parameter :position, 1, required: true
      parameter :points, 2, required: true
    end

    context "200" do
      let(:discipline_module_id) { DisciplineModule.last.id }
      let(:raw_post) {params.to_json}

      example "Create question group for discipline module" do
        request = {
          title: 'Html',
          position: 1,
          points: 2
        }
        do_request(request)
        
        expected_response = {
          status: 0,
          response: Api::V1::QuestionGroup::Representer.new(QuestionGroup.last)
        }
        expect(status).to eq(200)
        expect(response_body).to eq(expected_response.to_json)
      end
    end

    context "400" do
      let(:discipline_module_id) { DisciplineModule.last.id }
      let(:raw_post) {params.to_json}

      example "Error creating question group for discipline module" do
        request = {
          title: 'Html',
          position: 1
        }  
        do_request(request)
        
        expected_response = {
          status: 1,
          error: "points, is not a number, can't be blank"
        }
        expect(status).to eq(400)
        expect(response_body).to eq(expected_response.to_json)
      end
    end
  end

  post "/api/v1/modules/:discipline_module_id/question_groups/:id" do
    with_options with_example: true do
      parameter :title, 'Html', required: true
      parameter :position, 1, required: true
      parameter :points, 2, required: true
    end

    context "200" do
      let(:discipline_module_id) { DisciplineModule.last.id }
      let(:id) { QuestionGroup.last.id }
      let(:raw_post) {params.to_json}

      example "Update question group for discipline module" do
        request = {
          title: 'Html2',
          position: 2,
          points: 2
        }  
        do_request(request)

        expect(status).to eq(200)
        expect(response_body).to include("Html2")
      end
    end
  end

  delete "/api/v1/modules/:discipline_module_id/question_groups/:id" do
    context "200" do
      let(:discipline_module_id) { DisciplineModule.last.id }
      let(:id) { QuestionGroup.last.id }
      let(:raw_post) {params.to_json}

      example "Delete question group for discipline module" do
        qg_count = QuestionGroup.count
        do_request

        expect(status).to eq(200)
        expect(QuestionGroup.count).to eq(qg_count - 1)
      end
    end
  end

end