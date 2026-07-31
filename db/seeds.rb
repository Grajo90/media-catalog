ListItem.delete_all
Movie.delete_all
Episode.delete_all
Season.delete_all
TvShow.delete_all
List.delete_all

matrix = Movie.create!(
  title: "The Matrix",
  original_title: "The Matrix",
  year: 1999
)

shrek = Movie.create!(
  title: "Shrek",
  original_title: "Shrek",
  year: 2001
)

inception = Movie.create!(
  title: "Inception",
  original_title: "Inception",
  year: 2010
)

breaking_bad = TvShow.create!(
  title: "Breaking Bad",
  original_title: "Breaking Bad",
  year: 2008
)

season_1 = Season.create!(
  title: "Season 1",
  original_title: "Season 1",
  year: 2008,
  number: 1,
  tv_show: breaking_bad
)

pilot = Episode.create!(
  title: "Pilot",
  original_title: "Pilot",
  year: 2008,
  number: 1,
  season: season_1
)

cats_in_the_bag = Episode.create!(
  title: "Cat's in the Bag...",
  original_title: "Cat's in the Bag...",
  year: 2008,
  number: 2,
  season: season_1
)

top_10 = List.create!(name: "Top 10")

ListItem.create!(list: top_10, content: breaking_bad, position: 1)
ListItem.create!(list: top_10, content: matrix, position: 2)
ListItem.create!(list: top_10, content: pilot, position: 3)
ListItem.create!(list: top_10, content: season_1, position: 4)

best_movies = List.create!(name: "Best Movies")

ListItem.create!(list: best_movies, content: matrix, position: 1)
ListItem.create!(list: best_movies, content: shrek, position: 2)
ListItem.create!(list: best_movies, content: inception, position: 3)
