require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Session" do
  explanation "User session management"
  before do
    header "Content-Type", "application/json"
  end

  post "/api/v1/sign_in" do
    with_options with_example: true do
      parameter :email, 'admin@journal.com', required: true
      parameter :password, '12345678', required: true
    end

    context "200" do
      let(:user) { create(:user) }
      let(:raw_post) {params.to_json}

      example "Sign In" do
        request = {
          email: user.email,
          password: '12345678'
        }
        
        do_request(request)

        expected_response = {
          status: 0,
          response: Api::V1::User::Representer.new(user) 
        }
        expect(status).to eq(200)
        expect(response_body).to eq(expected_response.to_json)
      end
    end

    context "400" do
      let(:raw_post) {params.to_json}

      example "Sign In Error" do
        request = {
          email: 'nonexisting@user.com',
          password: '12345678'
        }
        
        do_request(request)

        expected_response = {
          status: 1,
          error: "Wrong email or password"
        }
        expect(status).to eq(400)
        expect(response_body).to eq(expected_response.to_json)
      end
    end
  end
end