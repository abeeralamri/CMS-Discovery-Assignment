class Admin::ProgramsController < ApplicationController
  # GET /admin/programs
  def index
    programs = Program.includes(:content_type).order(updated_at: :desc)
    programs = paginate(programs)
    render json: programs.as_json(
      only: [:id, :title, :description, :language_code, :status, :published_at, :cover_image_url],
      include: { content_type: { only: [:id, :ar_name, :en_name] } }
    )
  end

  # GET /admin/programs/:id
  def show
    program = Program.includes(:content_type, :content_items).find(params[:id])
    render json: program, include: [:content_type, :content_items]
  end

  # POST /admin/programs
  def create
    ActiveRecord::Base.transaction do
      program = Program.new(program_params.except(:content_type))
      attach_or_create_content_type!(program, program_params[:content_type])
      program.save!
      render json: program, status: :created
    end
  end

  # UPDATE /admin/programs/:id
  def update
    ActiveRecord::Base.transaction do
      program = Program.find(params[:id])
      program.assign_attributes(program_params.except(:content_type))
      attach_or_create_content_type!(program, program_params[:content_type]) if program_params[:content_type].present?
      program.save!
      render json: program
    end
  end

  def destroy
    program = Program.find_by(id: params[:id])
    return render json: { error: 'Program not found' }, status: :not_found unless program

    program.destroy!
    render json: { message: 'Program deleted successfully' }
  end

  # POST /admin/programs/:id/publish
  def publish
    program = Program.find(params[:id])

    at = parse_time(params[:published_at])
    if at && at > Time.current
      program.schedule_publish!(at)
    else
      program.publish_now!
    end

    render json: { message: 'Program published successfully', at: program.published_at }
  end

  private

  def program_params
    params.require(:program).permit(
      :content_type_id, :title, :description, :language_code,
      :cover_image_url, :status,
      content_type: [:ar_name, :en_name]
    )
  end

  def parse_time(value)
    return nil if value.blank?
    Time.iso8601(value) rescue nil
  end

  def attach_or_create_content_type!(program, content_type_payload)
    return if program.content_type_id.present?
    return if content_type_payload.blank?

    en = content_type_payload[:en_name].to_s.strip
    ar = content_type_payload[:ar_name].to_s.strip
    raise ActiveRecord::RecordInvalid.new(program), "content_type.en_name is required" if en.blank?

    program.content_type = ContentType.find_or_create_by!(en_name: en) do |ct|
      ct.ar_name  = ar
      ct.position = content_type_payload[:position] if content_type_payload.key?(:position)
    end
  end
end
