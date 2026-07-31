require 'rails_helper'

RSpec.describe ListContents, type: :use_case do
  describe ".call" do
    let(:list) do
      List.create!(name: "Top 10")
    end

    let(:content_1) do
      Movie.create!(
        title: "Matrix",
        original_title: "The Matrix",
        year: 1999
      )
    end

    let(:content_2) do
      Movie.create!(
        title: "Toy Story",
        original_title: "Toy Story",
        year: 1995
      )
    end

    let(:content_3) do
      Movie.create!(
        title: "Shrek",
        original_title: "Shrek",
        year: 2001
      )
    end

    before do
      ListItem.create!(
        list: list,
        content: content_3,
        position: 3
      )

      ListItem.create!(
        list: list,
        content: content_1,
        position: 1
      )

      ListItem.create!(
        list: list,
        content: content_2,
        position: 2
      )
    end

    let(:page) { 1 }
    let(:per_page) { 10 }
    let(:content_type) { nil }
    let(:result) do
      ListContents.call(
        list_id: list.id,
        page: page,
        per_page: per_page,
        content_type: content_type
      )
    end

    it "returns the contents of a list ordered by position" do
      expect(result.items.map(&:content)).to eq([ content_1, content_2, content_3 ])
    end

    context "when filtering by content type" do
      let(:content_2) do
        TvShow.create!(
          title: "Malcom in the Middle",
          original_title: "Malcom in the Middle",
          year: 2000
        )
      end

      let(:content_type) { "Movie" }

      it "returns only the requested content type" do
        expect(result.items.map(&:content)).to eq([ content_1, content_3 ])
      end
    end

    context "when requesting the second page" do
      let(:page) { 2 }
      let(:per_page) { 1 }

      it "returns the requested page" do
        expect(result.items.map(&:content)).to eq([ content_2 ])
      end

      it "returns pagination metadata" do
        expect(result.page).to eq(2)
        expect(result.per_page).to eq(1)
        expect(result.total).to eq(3)
      end
    end

    context "when the list has no contents" do
      let(:empty_list) do
        List.create!(name: "Empty list")
      end

      let(:result) do
      ListContents.call(
        list_id: empty_list.id,
      )
    end

      it "returns an empty result" do
        expect(result.items).to eq([])
        expect(result.total).to eq(0)
      end
    end

    context "when requesting a page without results" do
      let(:result) do
        ListContents.call(
          list_id: list.id,
          page: 10,
          per_page: 10
        )
      end

      it "returns an empty page" do
        expect(result.items).to eq([])
        expect(result.total).to eq(3)
      end
    end

    context "when filtering by an unsupported content type" do
      let(:result) do
        ListContents.call(
          list_id: list.id,
          content_type: "Documentary"
        )
      end

      it "raises an error" do
        expect { result }.to raise_error(ListContents::InvalidContentTypeError, "Unsupported content type: Documentary")
      end
    end
  end
end
