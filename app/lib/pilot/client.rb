require 'nokogiri'

module Pilot
  class Client
    HOST = 'https://pilot.khai.edu/pilot/'
    LOGIN_PATH = 'login.html'
    JOURNAL_URL = 'rectorskamark.html'

    def initialize(login, pass)
      @login = login
      @pass = pass
      @sessionid = nil
    end

    def get_sessionid
      creds = {
        username: @login,
        password: @pass
      }
      RestClient.post("#{HOST}#{LOGIN_PATH}", creds) { |response, request, result, &block|
        if [301, 302, 307].include? response.code
          response.cookies['JSESSIONID']
        else
          response.return!
        end
      }
    end

    def get_disciplines
      @sessionid = get_sessionid if @sessionid.nil?
      response = RestClient.get("#{HOST}#{JOURNAL_URL}", "Cookie" => "JSESSIONID=#{@sessionid}")
      doc = Nokogiri::HTML.fragment(response.body)
      doc.search('#disciplineId').search('option').map do |option| 
        {
          id: option.attribute("value").value,
          name: option.text.gsub("\n            ",'')
        }
      end
    end

    def get_groups(discipline_id)
      @sessionid = get_sessionid if @sessionid.nil?
      action = {
        action: 2,
        disciplineId: discipline_id
      }
      RestClient.post("#{HOST}#{JOURNAL_URL}", action, "Cookie" => "JSESSIONID=#{@sessionid}") { |response, request, result, &block|
        nil
      }
      response = RestClient.get("#{HOST}#{JOURNAL_URL}", "Cookie" => "JSESSIONID=#{@sessionid}")
      doc = Nokogiri::HTML.fragment(response.body)
      doc.search('#groupId').search('option').map do |option| 
        {
          id: option.attribute("value").value,
          name: option.text.gsub("\n            ",'')
        }
      end
    end

    def get_lessons(discipline_id, group_id)
      @sessionid = get_sessionid if @sessionid.nil?
      action = {
        action: 'load',
        groupId: group_id,
        disciplineId: discipline_id
      }
      RestClient.post("#{HOST}#{JOURNAL_URL}", action, "Cookie" => "JSESSIONID=#{@sessionid}") { |response, request, result, &block|
        nil
      }
      response = RestClient.get("#{HOST}#{JOURNAL_URL}", "Cookie" => "JSESSIONID=#{@sessionid}")
      doc = Nokogiri::HTML.fragment(response.body)
      doc.search('#idEnterType').search('option').map do |option| 
        {
          id: option.attribute("value").value,
          name: option.text.gsub("\n            ",'')
        }
      end
    end

    def get_students(discipline_id, group_id)
      @sessionid = get_sessionid if @sessionid.nil?
      action = {
        action: 'load',
        groupId: group_id,
        disciplineId: discipline_id
      }
      RestClient.post("#{HOST}#{JOURNAL_URL}", action, "Cookie" => "JSESSIONID=#{@sessionid}") { |response, request, result, &block|
        nil
      }
      response = RestClient.get("#{HOST}#{JOURNAL_URL}", "Cookie" => "JSESSIONID=#{@sessionid}")
      doc = Nokogiri::HTML.fragment(response.body)
      doc.search('#vedom1 tr.li_light').map do |tr|
        tds = tr.search('td')
        {
          position: tds[0].text.to_i - 1,
          name: tds[1].text
        }
      end
    end
  end
end
