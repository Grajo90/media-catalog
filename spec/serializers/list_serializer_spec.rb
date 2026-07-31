require 'rails_helper'
require "ostruct"

RSpec.describe ListSerializer, type: :serializer do
  describe "#serialize" do
    let(:page) { 1 }
    let(:per_page) { 10 }
    let(:result) do
      OpenStruct.new(
        list: list,
        items: items,
        page: page,
        per_page: per_page,
        total: total
      )
    end

    let(:serialized) { described_class.new(result).serialize }

    context "when the list is empty" do
      let(:list) { List.create!(name: "Empty list") }
      let(:items) { [] }
      let(:total) { 0 }
      it "returns the list metadata and empty items" do
        expect(serialized[:id]).to eq(list.id)
        expect(serialized[:name]).to eq(list.name)
        expect(serialized[:items]).to eq([])
        expect(serialized[:pagination]).to eq(
          {
            page: 1,
            per_page: 10,
            total: 0
          }
        )
      end
    end

    context "when the list contains" do
      let(:list) { List.create!(name: "Top 10") }
      let(:items) { [ item_1 ] }
      let(:item_1) do
        ListItem.create!(
          list: list,
          content: content,
          position: 2,
        )
      end
      let(:total) { 1 }

      context "a movie" do
        let(:content) { movie }
        let(:movie) do
          Movie.create!(
            title: "Shrek",
            original_title: "Shrek",
            year: 2001
          )
        end
        let(:item_1_serialized) do
          {
            id: item_1.id,
            position: 2,
            type: item_1.content_type,
            content: {
              id: movie.id,
              title: movie.title,
              original_title: movie.original_title,
              year: movie.year
            }
          }
        end

        it "serializes the movie item" do
          expect(serialized[:items]).to eq([ item_1_serialized ])
        end
      end

      context "a tv show" do
        let(:content) { tv_show }
        let(:tv_show) do
          TvShow.create!(
            title: "Malcom in the Middle",
            original_title: "Malcom in the Middle",
            year: 2000
          )
        end
        let(:item_1_serialized) do
          {
            id: item_1.id,
            position: 2,
            type: item_1.content_type,
            content: {
              id: tv_show.id,
              title: tv_show.title,
              original_title: tv_show.original_title,
              year: tv_show.year
            }
          }
        end

        it "serializes the tv show item" do
          expect(serialized[:items]).to eq([ item_1_serialized ])
        end
      end

      context "a season" do
        let(:content) { season }
        let(:season) do
          Season.create!(
            title: "First Season",
            original_title: "First Season",
            year: 2000,
            number: 1,
            tv_show: tv_show
          )
        end
        let(:tv_show) do
          TvShow.create!(
            title: "Malcom in the Middle",
            original_title: "Malcom in the Middle",
            year: 2000
          )
        end

        let(:item_1_serialized) do
          {
            id: item_1.id,
            position: 2,
            type: item_1.content_type,
            content: {
              id: season.id,
              number: season.number,
              title: season.title,
              original_title: season.original_title,
              year: season.year,
              tv_show: {
                id: tv_show.id,
                title: tv_show.title
              }
            }
          }
        end

        it "serializes the season item" do
          expect(serialized[:items]).to eq([ item_1_serialized ])
        end
      end

      context "an episode" do
        let(:content) { episode }
        let(:episode) do
          Episode.create!(
            title: "Pilot",
            original_title: "Pilot",
            year: 2000,
            number: 1,
            season: season
          )
        end
        let(:season) do
          Season.create!(
            title: "First Season",
            original_title: "First Season",
            year: 2000,
            number: 1,
            tv_show: tv_show
          )
        end
        let(:tv_show) do
          TvShow.create!(
            title: "Malcom in the Middle",
            original_title: "Malcom in the Middle",
            year: 2000
          )
        end

        let(:item_1_serialized) do
          {
            id: item_1.id,
            position: 2,
            type: item_1.content_type,
            content: {
              id: episode.id,
              number: episode.number,
              title: episode.title,
              original_title: episode.original_title,
              year: episode.year,
              season: {
                id: episode.season.id,
                number: episode.season.number,
                tv_show: {
                  id: episode.season.tv_show.id,
                  title: episode.season.tv_show.title
                }
              }
            }
          }
        end

        it "serializes the episode item" do
          expect(serialized[:items]).to eq([ item_1_serialized ])
        end
      end
    end
  end
end
