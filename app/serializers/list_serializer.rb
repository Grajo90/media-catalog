class ListSerializer
  def initialize(data)
    @data = data
  end

  private attr_reader :data

  def serialize
    {
      id: data.list.id,
      name: data.list.name,
      items: data.items.map { |item| serialize_item(item) },
      pagination: {
        page: data.page,
        per_page: data.per_page,
        total: data.total
      }
    }
  end

  private def serialize_item(item)
    {
      id: item.id,
      position: item.position,
      type: item.content_type,
      content: serialize_content(item.content)
    }
  end

  private def serialize_content(content)
    case content
    when Movie
      serialize_movie(content)
    when TvShow
      serialize_tv_show(content)
    when Season
      serialize_season(content)
    when Episode
      serialize_episode(content)
    end
  end

  private def serialize_movie(movie)
    {
      id: movie.id,
      title: movie.title,
      original_title: movie.original_title,
      year: movie.year
    }
  end

  private def serialize_tv_show(tv_show, summary: false)
    result = {
      id: tv_show.id,
      title: tv_show.title
    }

    return result if summary

    result.merge(
      original_title: tv_show.original_title,
      year: tv_show.year
    )
  end

  private def serialize_season(season, summary: false)
    result = {
      id: season.id,
      number: season.number,
      tv_show: serialize_tv_show(season.tv_show, summary: true)
    }

    return result if summary

    result.merge(
      title: season.title,
      original_title: season.original_title,
      year: season.year
    )
  end

  private def serialize_episode(episode)
    {
      id: episode.id,
      number: episode.number,
      title: episode.title,
      original_title: episode.original_title,
      year: episode.year,
      season: serialize_season(episode.season, summary: true)
    }
  end
end
