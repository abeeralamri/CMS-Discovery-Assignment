class Admin::ContentTypesController < ApplicationController
  # GET /admin/content_types
  def index
    content_types = ContentType.order(:en_name)
    render json: content_types.as_json(only: [:id, :ar_name, :en_name])
  end

  # GET /admin/content_types/:id
  def show
    content_type = ContentType.find(params[:id])
    render json: content_type.as_json(only: [:id, :ar_name, :en_name])
  end
end
