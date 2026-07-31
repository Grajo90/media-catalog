class ListContents
  class InvalidContentTypeError < StandardError
  end
  class InvalidPaginationError < StandardError
  end

  ALLOWED_CONTENT_TYPES = %w[
    Movie
    TvShow
    Season
    Episode
  ].freeze

  Result = Data.define(
    :list,
    :items,
    :page,
    :per_page,
    :total
  )

  def self.call(...)
    new(...).call
  end

  def initialize(list_id:, page: 1, per_page: 10, content_type: nil)
    @list_id = list_id
    @page = page
    @per_page = per_page
    @content_type = content_type
  end

  def call
    validate_content_type!
    validate_pagination!

    list = List.find(@list_id)

    items = list.list_items
    items = items.where(content_type: @content_type) if @content_type.present?
    items = items.order(:position)

    total = items.count

    items = items.offset((@page - 1) * @per_page)
    items = items.limit(@per_page)

    Result.new(
      list: list,
      items: items,
      page: @page,
      per_page: @per_page,
      total: total
    )
  end

  private def validate_content_type!
    return if @content_type.blank?
    return if ALLOWED_CONTENT_TYPES.include?(@content_type)

    raise InvalidContentTypeError, "Unsupported content type: #{@content_type}"
  end

  private def validate_pagination!
    @page = validate_pagination_value(@page, "Page")
    @per_page = validate_pagination_value(@per_page, "Per page")
  end

  private def validate_pagination_value(value, name)
    integer = Integer(value, exception: false)

    unless integer&.positive?
      raise InvalidPaginationError, "#{name} must be a positive integer, but value is #{value}"
    end

    integer
  end
end
