class Relationship < ActiveRecord::Base
  class GetCurrent < Trailblazer::Operation
    step :get_group
    step :get_relationships

    def get_group(options, params:, current_user:, **)
      options[:group] = current_user.groups.where(year: Time.zone.now.year).first
      if options[:group].nil?
        options[:error_msg] = 'User is not in a group'
        return false
      end
      true
    end

    def get_relationships(options, params:, current_user:, **)
      options[:relationships] = options[:group].relationships
    end
  end
end