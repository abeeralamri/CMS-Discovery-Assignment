class ProgramsController < ApplicationController
  # GET /programs
  def index
    programs = Program.where(status: 'published').includes(:content_type)
    programs = programs.where(language_code: params[:lang]) if params[:lang].present?

    # Filter by type, either by ID or name
    type = params[:type].presence || params[:content_type].presence
    if type.present?
      if type.to_s =~ /\A\d+\z/
        programs = programs.where(content_type_id: type.to_i)
      else
        programs = programs.joins(:content_type).where(content_types: { en_name: type.to_s })
      end
    end

    programs = paginate(programs.order(published_at: :desc))
    render json: {
      data: programs.as_json(
        only: [:id, :title, :description, :language_code, :status, :published_at, :cover_image_url],
        include: { content_type: { only: [:id, :ar_name, :en_name] } }
      ),
      meta: pagination_meta(programs)
    }
  end

  # GET /programs/:id
  def show
    program = Program.where(status: 'published').includes(:content_type).find(params[:id])
    render json: program.as_json(
      only: [:id, :title, :description, :language_code, :status, :published_at, :cover_image_url],
      include: { content_type: { only: [:id, :ar_name, :en_name] } }
    )
  end
end
