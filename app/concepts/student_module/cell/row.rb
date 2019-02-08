class StudentModule < ActiveRecord::Base
  class Cell
    class Row < Trailblazer::Cell
      def student
        model
      end

      def visit
        options[:visit]
      end

      def student_module
        StudentModule.where(user_id: student.id, visit_id: visit.id).where.not(status: StudentModule.statuses['deleted']).first
      end

      def status
        if student_module.present?
          I18n.t("student_module.statuses.#{student_module.status}")
        else
          I18n.t("student_module.statuses.empty")
        end
      end

      def checked
        return I18n.t("student_module.checked.done") if student_module.present? && student_module.checked
        return I18n.t("student_module.checked.not") if student_module.present? && !student_module.checked
        ""
      end

      def total
        return student_module.total if student_module.present?
        ""
      end

      def open_link
        return "" if student_module.nil?
        link_to I18n.t("student_module.check"), student_module_path(student_module), target: "_blank"
      end

      def cancel_link
        return "" if student_module.nil?
        link_to I18n.t("student_module.cancel"), student_module_path(student_module), method: :delete, data: {confirm: "Are you sure?"}
      end

      def copy_result_link
        return "" if student_module.nil?
        link_to I18n.t("student_module.copy_result"), copy_result_student_module_path(student_module)
      end
    end
  end
end