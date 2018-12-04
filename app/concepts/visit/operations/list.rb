class Visit < ActiveRecord::Base
  class List < Trailblazer::Operation
    step :get_relationship
    step :check_access
    step :get_visits

    def get_relationship(options, params:, current_user:, **)
      options[:relationship] = Relationship.where(id: params[:relationship_id]).first
      if options[:relationship].nil?
        options[:error_msg] = 'Relationship not found'
        return false
      end
      true
    end

    def check_access(options, params:, current_user:, **)
      options[:group] = current_user.groups.where(id: options[:relationship].group_id).first
      if options[:group].nil?
        options[:error_msg] = 'User is not in a relationship\'s group'
        return false
      end
      true
    end

    def get_visits(options, params:, current_user:, **)
      options[:visits] = options[:relationship].visits
      options[:visits] = options[:visits].where(kind: params[:kind]) if params[:kind]
      true
    end
  end
end