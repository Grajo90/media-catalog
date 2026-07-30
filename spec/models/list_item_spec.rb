require 'rails_helper'

RSpec.describe ListItem, type: :model do
  describe "validations" do
    let(:list) do
      List.new(name: "Top 10")
    end

    let(:content) do
      Movie.new(
        title: "Shrek",
        original_title: "Shrek",
        year: 2001
      )
    end

    let(:position) { 1 }

    let(:list_item) do
      ListItem.new(
        list: list,
        content: content,
        position: position
      )
    end

    it "is valid with all required attributes" do
      expect(list_item).to be_valid
    end

    context "when list is not present" do
      let(:list) { nil }

      it "is invalid" do
        expect(list_item).not_to be_valid
      end
    end

    context "when content is not present" do
      let(:content) { nil }

      it "is invalid" do
        expect(list_item).not_to be_valid
      end
    end

    context "when position is not present" do
      let(:position) { nil }

      it "is invalid" do
        expect(list_item).not_to be_valid
      end
    end

    context "when position is duplicated in the same list" do
      let(:list) do
        List.create!(name: "Top 10 Movies")
      end

      before do
        ListItem.create!(
          list: list,
          content: Movie.create!(
            title: "Shrek",
            original_title: "Shrek",
            year: 2001
          ),
          position: 1
        )
      end

      it "is invalid" do
        expect(list_item).not_to be_valid
      end
    end

    context "when a different list has the same position" do
      let(:list) do
        List.create!(name: "Top 10")
      end

      let(:other_list) do
        List.create!(name: "Comedy")
      end

      let(:list_item) do
        ListItem.new(
          list: other_list,
          content: content,
          position: position
        )
      end

      before do
        ListItem.create!(
          list: list,
          content: Movie.create!(
            title: "Shrek",
            original_title: "Shrek",
            year: 2001
          ),
          position: 1
        )
      end

      it "is valid" do
        expect(list_item).to be_valid
      end
    end

    context "when the same content appears twice in a list" do
      let(:list) do
        List.create!(name: "Top 10")
      end

      let(:content) do
        Movie.new(
          title: "Shrek",
          original_title: "Shrek",
          year: 2001
        )
      end

      let(:list_item) do
        ListItem.new(
          list: list,
          content: content,
          position: 2
        )
      end

      before do
        ListItem.create!(
          list: list,
          content: content,
          position: 5
        )
      end

      it "is valid if positions are different" do
        expect(list_item).to be_valid
      end
    end
  end
end
