module Paginatable
  extend ActiveSupport::Concern

  DEFAULT_PER = 50
  MAX_PER     = 100

  def paginate(scope, default_per: DEFAULT_PER)
    page = params.fetch(:page, 1).to_i
    per  = params.fetch(:per_page, default_per).to_i
    page = 1 if page < 1
    per  = 1 if per  < 1
    per  = [per, MAX_PER].min

    if scope.respond_to?(:page) # kaminari present
      collection = scope.page(page).per(per)
      @pagination = {
        total:        collection.total_count,
        total_pages:  collection.total_pages,
        current_page: collection.current_page,
        per_page:     collection.limit_value
      }
      collection
    else
      total       = scope.unscope(:order).count
      total_pages = (total.to_f / per).ceil
      offset      = (page - 1) * per
      records     = scope.limit(per).offset(offset)
      @pagination = {
        total:        total,
        total_pages:  total_pages,
        current_page: page,
        per_page:     per
      }
      records
    end
  end

  def pagination_meta(_collection = nil)
    @pagination || {}
  end
end
