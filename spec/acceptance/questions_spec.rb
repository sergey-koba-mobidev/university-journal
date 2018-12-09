require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Questions" do
  explanation "Question for question groups. Uses Authorization header to provide Bearer token. Only admins and Teachers can access"
  before do
    DbSeedService.new.call
    header "Content-Type", "application/json"
    header "Authorization", "Bearer #{User.first.api_token}"
  end

  get "/api/v1/question_groups/:question_group_id/questions" do

    context "200" do
      let(:question_group_id) { QuestionGroup.last.id }
      let(:raw_post) {params.to_json}

      example "Get questions for question group" do
        do_request

        expected_response = {
          status: 0,
          response: Api::V1::Question::Representer.for_collection.new(QuestionGroup.last.questions.all)
        }
        expect(status).to eq(200)
        expect(response_body).to eq(expected_response.to_json)
      end
    end
  end

  post "/api/v1/question_groups/:question_group_id/questions" do
    with_options with_example: true do
      parameter :description, 'What is html?', required: true
      parameter :kind, 0, required: true
      parameter :answer, "markup language", required: true
      parameter :variants, "[]", required: true
    end

    context "200" do
      let(:question_group_id) { QuestionGroup.last.id }
      let(:raw_post) {params.to_json}

      example "Create question for question groups" do
        request = {
          description: 'What is html?',
          kind: 0,
          answer: "markup language",
          variants: "[]"
        }
        do_request(request)
        
        expected_response = {
          status: 0,
          response: Api::V1::Question::Representer.new(Question.last)
        }
        expect(status).to eq(200)
        expect(response_body).to eq(expected_response.to_json)
      end
    end

    context "400" do
      let(:question_group_id) { QuestionGroup.last.id }
      let(:raw_post) {params.to_json}

      example "Error creating question for question group" do
        request = {
          description: 'What is html?',
          answer: "markup language",
          variants: "[]"
        } 
        do_request(request)
        
        expected_response = {
          status: 1,
          error: "kind, is not a number, can't be blank"
        }
        expect(status).to eq(400)
        expect(response_body).to eq(expected_response.to_json)
      end
    end
  end

  post "/api/v1/question_groups/:question_group_id/questions/:id" do
    with_options with_example: true do
      parameter :description, 'What is html?', required: true
      parameter :kind, 0, required: true
      parameter :answer, "markup language", required: true
      parameter :variants, "[]", required: true
    end

    context "200" do
      let(:question_group_id) { QuestionGroup.last.id }
      let(:id) { Question.last.id }
      let(:raw_post) {params.to_json}

      example "Update question for question group" do
        request = {
          description: 'What is Html5?',
          kind: 0,
          answer: "markup language",
          variants: "[]"
        }  
        do_request(request)

        expect(status).to eq(200)
        expect(response_body).to include("Html5?")
      end
    end
  end

  delete "/api/v1/question_groups/:question_group_id/questions/:id" do
    context "200" do
      let(:question_group_id) { QuestionGroup.last.id }
      let(:id) { Question.last.id }
      let(:raw_post) {params.to_json}

      example "Delete question for question group" do
        q_count = Question.count
        do_request

        expect(status).to eq(200)
        expect(Question.count).to eq(q_count - 1)
      end
    end
  end

end