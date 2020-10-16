class Question < ActiveRecord::Base
  class Cell
    class Check < Trailblazer::Cell
      property :id
      property :description
      property :kind
      property :variants

      def index
        options[:index] + 1
      end

      def student_module
        options[:student_module]
      end

      def question
        Question.find(id)
      end

      def right_answer
        answers = ""
        ans = student_module.right_answers.select {|answer| answer["id"] == id }
        if ans.first.present?
          ans = ans.first["answer"]
          ans = JSON.parse(ans) if ans.present? && ans.size > 1
          ans = [ans.to_i] if ans.present? && !ans.kind_of?(Array)
          ans = [] if ans.nil?
        else
          ans = []
        end
        if variants.present? && variants != '[]'
          variants.each_index do |index|
            answers += "#{variants[index]} <br/>" if ans.include?(index)
          end
        end
        answers
      end

      def answer
        send("answer_#{kind}")
      end

      def answer_text
        ans = student_module.answers.select {|answer| answer["id"] == id }.first
        CGI.escapeHTML(ans["answer"] || "")
      end

      def answer_one
        render_answer
      end

      def answer_many
        render_answer
      end

      def render_answer
        answers = ""
        ans = student_module.answers.select {|answer| answer["id"] == id }
        if ans.present?
          ans = ans.first["answer"]
          ans = JSON.parse(ans) if ans.present? && ans.size > 1
          ans = [ans.to_i] if ans.present? && !ans.kind_of?(Array)
          ans = [] if ans.nil?
        else
          ans = []
        end
        if variants.present? && variants != '[]'
          variants.each_index do |index|
            answers += "#{variants[index]} <br/>" if ans.include?(index)
          end
        end
        answers
      end

      def result
        r = student_module.results.select {|r| r["id"] == id }
        if r.present?
          r.first["result"]
        else
          nil
        end
      end
    end
  end
end
