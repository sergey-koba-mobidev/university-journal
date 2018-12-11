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

  post "/api/v1/relationships/:relationship_id/modules/:id/questions/:question_id/answer" do
    with_options with_example: true do
      parameter :answer, '1', required: true
    end

    context "200" do
      let(:relationship_id) { Relationship.last.id }
      let(:id) { Visit.first.id }
      let(:student_module) { StudentModule::Get.(params: {id: id}, current_user: User.last)[:student_module] }
      let(:question_id) { student_module.questions[0]["id"] }
      let(:raw_post) {params.to_json}

      example "Post answer for module question" do    
        request = {
          answer: "1"
        }

        do_request(request)
        
        expected_response = {
          status: 0,
          response: Api::V1::StudentModule::Representer.new(StudentModule.last)
        }
        expect(status).to eq(200)
        expect(response_body).to include("{\"id\":#{question_id},\"answer\":\"1\"}")
      end
    end
  end

  post "/api/v1/relationships/:relationship_id/modules/:id/finish" do

    context "200" do
      let(:relationship_id) { Relationship.last.id }
      let(:id) { Visit.first.id }
      let(:raw_post) {params.to_json}

      example "Finish module" do    
        StudentModule::Generate.(params: {id: id}, current_user: User.last)
        do_request
        
        expected_response = {
          status: 0,
          response: Api::V1::StudentModule::Representer.new(StudentModule.last)
        }
        expect(status).to eq(200)
        expect(response_body).to eq(expected_response.to_json)
        expect(StudentModule.last.status).to eq("finished")
      end
    end
  end
  
end