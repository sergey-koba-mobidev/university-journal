module Session
  class SignIn < Trailblazer::Operation
    step :find_user
    step :check_password

    def find_user(options, params:, **)
      options[:user] = User.find_by_email(params[:email])
      return false unless options[:user]
      true
    end

    def check_password(options, params:, **)
      options[:user].valid_password?(params[:password])
    end
  end
end