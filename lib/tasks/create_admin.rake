namespace :db do
  class String
    def pretty
      self.colorize(color: :light_green, background: :default)
    end
  end

  desc 'Fill database with admin data'
  task create_admin: :environment do
    # Admin
    puts "\n== Creating users"
    user = CreateAdminService.new.call
    puts "Created admin user : ".pretty << "#{user.email}/123456"
  end
end