require 'rails_helper'

RSpec.describe Episode, type: :model do
  describe "validations" do
    let(:title) { "Pilot" }
    let(:original_title) { "Pilot" }
    let(:year) { 2000 }
    let(:number) { 1 }

    let(:tv_show) do
      TvShow.new(
        title: "Malcom in the Middle",
        original_title: "Malcom in the Middle",
        year: 2000
      )
    end

    let(:season) do
      Season.new(
        title: "First Season",
        original_title: "First Season",
        year: 2000,
        number: 1,
        tv_show: tv_show
      )
    end

    let(:episode) do
      Episode.new(
        title: title,
        original_title: original_title,
        year: year,
        number: number,
        season: season
      )
    end

    it "is valid with all required attributes" do
      expect(episode).to be_valid
    end

    context "when title is not present" do
      let(:title) { nil }

      it "is invalid" do
        expect(episode).not_to be_valid
      end
    end

    context "when original title is not present" do
      let(:original_title) { nil }

      it "is invalid" do
        expect(episode).not_to be_valid
      end
    end

    context "when year is not present" do
      let(:year) { nil }

      it "is invalid" do
        expect(episode).not_to be_valid
      end
    end

    context "when number is not present" do
      let(:number) { nil }
      it "is invalid" do
        expect(episode).not_to be_valid
      end
    end

    context "when season is not present" do
      let(:season) { nil }
      it "is invalid" do
        expect(episode).not_to be_valid
      end
    end

    context "when episode number is duplicated on the same season" do
      let(:tv_show) do
        TvShow.create!(
          title: "Malcom in the Middle",
          original_title: "Malcom in the Middle",
          year: 2000
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

      before do
        Episode.create!(
          title: "Pilot",
          original_title: "Pilot",
          year: 2000,
          number: 1,
          season: season
        )
      end

      it "is invalid" do
        expect(episode).not_to be_valid
      end
    end

    context "when a different season has the same episode number" do
      let(:tv_show) do
        TvShow.create!(
          title: "Malcom in the Middle",
          original_title: "Malcom in the Middle",
          year: 2000
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

      let(:other_season) do
        Season.create!(
          title: "Second Season",
          original_title: "Second Season",
          year: 2001,
          number: 2,
          tv_show: tv_show
        )
      end

      let(:episode) do
        Episode.new(
          title: title,
          original_title: original_title,
          year: year,
          number: number,
          season: other_season
        )
      end

      before do
        Episode.create!(
          title: "Pilot",
          original_title: "Pilot",
          year: 2000,
          number: 1,
          season: season
        )
      end

      it "is valid" do
        expect(episode).to be_valid
      end
    end
  end
end
