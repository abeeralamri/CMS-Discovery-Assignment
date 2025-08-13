class ContentItemsController < ApplicationController
  # GET /content_items
  def index
    items = ContentItem.published
                     .joins(program: :content_type)
                     .merge(Program.published)
                     .order('content_items.published_at DESC')

    items = items.where(programs: { id: params[:program_id] }) if params[:program_id].present?
    items = items.where(content_types: { en_name: params[:content_type] }) if params[:content_type].present?
    items = items.where('content_items.language_code = ?', params[:lang]) if params[:lang].present?

    items = paginate(items)
    render json: {
      data: items.as_json(only: [:id, :title, :description, :language_code, :duration_seconds, :published_at, :audio_video_url, :thumbnail_url]),
      meta: pagination_meta(items)
    }
  end

  # GET /content_items/:id
  def show
    item = ContentItem.published.find_by(id: params[:id])
    return render json: { error: 'ContentItem not found' }, status: :not_found unless item

    render json: item
  end
end
