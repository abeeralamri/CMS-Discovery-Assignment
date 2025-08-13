class Admin::ContentItemsController < ApplicationController
  before_action :set_content_item, only: [:show, :update, :destroy, :publish]
  before_action :set_program,      only: [:create]

  # GET /admin/content_items
  def index
    items = ContentItem.order(updated_at: :desc)
    items = items.where(program_id: params[:program_id]) if params[:program_id].present?
    items = items.where(language_code: params[:lang])     if params[:lang].present?

    items = paginate(items)
    render json: items.as_json(
      only: [:id, :program_id, :title, :description, :language_code,
             :duration_seconds, :published_at, :status, :audio_video_url, :thumbnail_url]
    )
  end

  # GET /admin/content_items/:id
  def show
    render json: @content_item
  end

  # POST /admin/content_items
  def create
    item = @program.content_items.new(item_create_params.except(:program_id))
    if item.save
      render json: item, status: :created
    else
      render json: item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/content_items/:id
  def update
    if @content_item.update(item_update_params)
      render json: @content_item
    else
      render json: @content_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /admin/content_items/:id
  def destroy
    @content_item.destroy!
    head :no_content
  end

  # POST /admin/content_items/:id/publish
  def publish
    at = parse_time(params[:published_at])
    if at && at > Time.current
      @content_item.schedule_publish!(at)
      render json: { message: 'Item scheduled', at: @content_item.published_at }
    else
      unless @content_item.program.status_published?
        return render json: { error: 'Program must be published before publishing items' }, status: :unprocessable_entity
      end
      @content_item.publish_now!
      render json: { message: 'Item published', at: @content_item.published_at }
    end
  end

  private

  def set_content_item
    @content_item = ContentItem.find(params[:id])
  end

  def set_program
    cid = params[:program_id] || params.dig(:content_item, :program_id)
    return render(json: { error: 'program_id is required' }, status: :unprocessable_entity) if cid.blank?
    @program = Program.find(cid)
  end

  def item_create_params
    params.require(:content_item).permit(
      :program_id, :title, :description, :language_code,
      :duration_seconds, :published_at, :status,
      :audio_video_url, :thumbnail_url
    )
  end

  def item_update_params
    params.require(:content_item).permit(
      :title, :description, :language_code,
      :duration_seconds, :published_at, :status,
      :audio_video_url, :thumbnail_url
    )
  end

  def parse_time(value)
    return nil if value.blank?
    Time.iso8601(value) rescue nil
  end
end
