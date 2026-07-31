require "rails_helper"

RSpec.describe ListsController, type: :request do
  describe "GET /lists/:id" do
    subject { get "/lists/#{list.id}" }

    context "when the list is empty" do
      let(:list) { List.create!(name: "Empty list") }

      it "returns the list metadata and empty items" do
        subject

        expect(response).to have_http_status(:ok)

        body = JSON.parse(response.body)

        expect(body["id"]).to eq(list.id)
        expect(body["name"]).to eq(list.name)
        expect(body["items"]).to eq([])
        expect(body["pagination"]).to eq(
          {
            "page" => 1,
            "per_page" => 10,
            "total" => 0
          }
        )
      end
    end

    context "when the list contains a movie" do
      let(:list) { List.create!(name: "Top 10") }
      let(:movie) { Movie.create!(title: "Shrek", original_title: "Shrek", year: 2001) }
      let(:list_item) { ListItem.create!(list: list, content: movie, position: 1) }

      before do
        list_item
      end

      it "returns the list and movie" do
        subject

        expect(response).to have_http_status(:ok)

        body = JSON.parse(response.body)

        expect(body["id"]).to eq(list.id)
        expect(body["name"]).to eq(list.name)
        expect(body["items"]).to eq(
          [
            {
              "id" => list_item.id,
              "position" => 1,
              "type" => "Movie",
              "content" => {
                "id" => movie.id,
                "title" => "Shrek",
                "original_title" => "Shrek",
                "year" => 2001
              }
            }
          ]
        )
      end
    end

    context "when the list contains different content types" do
      let(:list) { List.create!(name: "Top 10") }
      let(:tv_show) { TvShow.create!(title: "Malcom in the Middle", original_title: "Malcom in the Middle", year: 2000) }
      let(:season) { Season.create!(title: "First Season", original_title: "First Season", year: 2000, number: 1, tv_show: tv_show) }
      let(:episode) { Episode.create!(title: "Pilot", original_title: "Pilot", year: 2000, number: 1, season: season) }
      let(:movie) { Movie.create!(title: "Shrek", original_title: "Shrek", year: 2001) }

      let(:movie_item) { ListItem.create!(list: list, content: movie, position: 3) }
      let(:tv_show_item) { ListItem.create!(list: list, content: tv_show, position: 1) }
      let(:season_item) { ListItem.create!(list: list, content: season, position: 4) }
      let(:episode_item) { ListItem.create!(list: list, content: episode, position: 2) }

      before do
        movie_item
        tv_show_item
        season_item
        episode_item
      end

      it "returns the items ordered by position" do
        subject

        expect(response).to have_http_status(:ok)

        body = JSON.parse(response.body)

        expect(body["items"].map { |item| item["position"] }).to eq([ 1, 2, 3, 4 ])
        expect(body["items"].map { |item| item["type"] }).to eq(
          [ "TvShow", "Episode", "Movie", "Season" ]
        )
      end

      it "returns the season with its tv show" do
        subject

        body = JSON.parse(response.body)

        season_item = body["items"].find { |item| item["type"] == "Season" }

        expect(season_item["content"]["id"]).to eq(season.id)
        expect(season_item["content"]["tv_show"]["id"]).to eq(tv_show.id)
      end

      it "returns the episode with its season and tv show" do
        subject

        body = JSON.parse(response.body)

        episode_item = body["items"].find { |item| item["type"] == "Episode" }

        expect(episode_item["content"]["id"]).to eq(episode.id)
        expect(episode_item["content"]["season"]["id"]).to eq(season.id)
        expect(episode_item["content"]["season"]["tv_show"]["id"]).to eq(tv_show.id)
      end
    end

    context "when pagination is requested" do
      let(:list) { List.create!(name: "Top 10") }
      let(:movie_1) { Movie.create!(title: "Movie 1", original_title: "Movie 1", year: 2001) }
      let(:movie_2) { Movie.create!(title: "Movie 2", original_title: "Movie 1", year: 2002) }
      let(:movie_3) { Movie.create!(title: "Movie 3", original_title: "Movie 1", year: 2003) }

      let(:list_item_1) do
        ListItem.create!(list: list, content: movie_1, position: 1)
      end

      let(:list_item_2) do
        ListItem.create!(list: list, content: movie_2, position: 2)
      end

      let(:list_item_3) do
        ListItem.create!(list: list, content: movie_3, position: 3)
      end

      before do
        list_item_1
        list_item_2
        list_item_3
      end

      subject { get "/lists/#{list.id}?page=2&per_page=2" }

      it "returns the requested page and pagination metadata" do
        subject

        expect(response).to have_http_status(:ok)

        body = JSON.parse(response.body)

        expect(body["items"].count).to eq(1)
        expect(body["items"].map { |item| item["content"]["id"] })
          .to eq([ movie_3.id ])

        expect(body["pagination"]).to eq(
          {
            "page" => 2,
            "per_page" => 2,
            "total" => 3
          }
        )
      end
    end

    context "when filtering by content type" do
      let(:list) { List.create!(name: "Top 10") }
      let(:movie_1) { Movie.create!(title: "Shrek", original_title: "Shrek", year: 2001) }
      let(:movie_2) { Movie.create!(title: "Matrix", original_title: "The Matrix", year: 1999) }
      let(:tv_show) { TvShow.create!(title: "Malcolm in the Middle", original_title: "Malcolm in the Middle", year: 2000) }
      let(:movie_item_1) { ListItem.create!(list: list, content: movie_1, position: 1) }
      let(:tv_show_item) { ListItem.create!(list: list, content: tv_show, position: 2) }
      let(:movie_item_2) { ListItem.create!(list: list, content: movie_2, position: 3) }

      before do
        movie_item_1
        tv_show_item
        movie_item_2
      end

      subject { get "/lists/#{list.id}?content_type=Movie" }

      it "returns only items matching the content type" do
        subject

        expect(response).to have_http_status(:ok)

        body = JSON.parse(response.body)

        expect(body["items"].map { |item| item["id"] }).to eq([ movie_item_1.id, movie_item_2.id ])
        expect(body["items"].map { |item| item["type"] }).to eq([ "Movie", "Movie" ])
        expect(body["pagination"]["total"]).to eq(2)
      end
    end

    context "when the list does not exist" do
      let(:list_id) { 9999999 }

      subject { get "/lists/#{list_id}" }

      it "returns not found" do
        subject

        expect(response).to have_http_status(:not_found)

        body = JSON.parse(response.body)

        expect(body).to eq(
          {
            "error" => {
              "code" => "LIST_NOT_FOUND",
              "message" => "List not found"
            }
          }
        )
      end
    end

    context "when the content_type is invalid" do
      let(:list) { List.create!(name: "Top 10") }

      subject { get "/lists/#{list.id}?content_type=InvalidType" }

      it "returns an invalid content type error" do
        subject

        expect(response).to have_http_status(:bad_request)

        body = JSON.parse(response.body)

        expect(body).to eq(
          {
            "error" => {
              "code" => "INVALID_CONTENT_TYPE",
              "message" => "Unsupported content type: InvalidType"
            }
          }
        )
      end
    end

    context "when page is invalid" do
      let(:list) { List.create!(name: "Top 10") }

      context "when it is not an integer" do
        subject { get "/lists/#{list.id}?page=foo" }

        it "returns an invalid pagination error" do
          subject

          expect(response).to have_http_status(:bad_request)

          body = JSON.parse(response.body)

          expect(body).to eq(
            {
              "error" => {
                "code" => "INVALID_PAGINATION",
                "message" => "Page must be a positive integer, but value is foo"
              }
            }
          )
        end
      end

      context "when it is negative" do
        subject { get "/lists/#{list.id}?page=-2" }

        it "returns an invalid pagination error" do
          subject

          expect(response).to have_http_status(:bad_request)

          body = JSON.parse(response.body)

          expect(body).to eq(
            {
              "error" => {
                "code" => "INVALID_PAGINATION",
                "message" => "Page must be a positive integer, but value is -2"
              }
            }
          )
        end
      end
    end

    context "when per_page is invalid" do
      let(:list) { List.create!(name: "Top 10") }

      context "when it is not an integer" do
        subject { get "/lists/#{list.id}?per_page=bar" }

        it "returns an invalid pagination error" do
          subject

          expect(response).to have_http_status(:bad_request)

          body = JSON.parse(response.body)

          expect(body).to eq(
            {
              "error" => {
                "code" => "INVALID_PAGINATION",
                "message" => "Per page must be a positive integer, but value is bar"
              }
            }
          )
        end
      end

      context "when it is negative" do
        subject { get "/lists/#{list.id}?per_page=-1" }

        it "returns an invalid pagination error" do
          subject

          expect(response).to have_http_status(:bad_request)

          body = JSON.parse(response.body)

          expect(body).to eq(
            {
              "error" => {
                "code" => "INVALID_PAGINATION",
                "message" => "Per page must be a positive integer, but value is -1"
              }
            }
          )
        end
      end
    end
  end
end
