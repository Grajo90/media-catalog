class ListsController < ApplicationController
  rescue_from ListContents::InvalidContentTypeError, with: :render_invalid_content_type
  rescue_from ListContents::InvalidPaginationError, with: :render_invalid_pagination

  def show
    result = ListContents.call(
      list_id: params[:id],
      page: params.fetch(:page, 1),
      per_page: params.fetch(:per_page, 10),
      content_type: params[:content_type]
    )

    render json: ListSerializer.new(result).serialize
  end

  private def render_invalid_content_type(error)
    render json: {
      error: {
        code: "INVALID_CONTENT_TYPE",
        message: error.message
      }
    }, status: :bad_request
  end

  private def render_invalid_pagination(error)
    render json: {
      error: {
        code: "INVALID_PAGINATION",
        message: error.message
      }
    }, status: :bad_request
  end
end
