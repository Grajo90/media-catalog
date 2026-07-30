class ListContents
  ALLOWED_CONTENT_TYPES = %w[
    Movie
    TvShow
    Season
    Episode
  ].freeze

  Result = Data.define(
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

    list = List.find(@list_id)

    items = list.list_items
    items = items.where(content_type: @content_type) if @content_type.present?
    items = items.order(:position)

    total = items.count

    items = items.offset((@page - 1) * @per_page)
    items = items.limit(@per_page)

    Result.new(
      items: items,
      page: @page,
      per_page: @per_page,
      total: total
    )
  end

  def validate_content_type!
    return if @content_type.blank?
    return if ALLOWED_CONTENT_TYPES.include?(@content_type)

    raise ArgumentError, "Unsupported content type: #{@content_type}"
  end
end
