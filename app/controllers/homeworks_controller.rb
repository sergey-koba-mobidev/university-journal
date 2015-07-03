class HomeworksController < ApplicationController
  def create
    @homework = Homework.create(homework_params)
  end

  private

  def homework_params
    params.require(:homework).permit(:document, :comment_text)
  end

end