class ArchiveController < ApplicationController
  before_action AdminOrTeacherActionCallback

  def index
    @relationships_grid = initialize_grid(Relationship,
      include: [:semester, :discipline, :group],
      order: 'created_at'
    )
  end
end
