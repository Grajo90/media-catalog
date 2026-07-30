require 'rails_helper'

RSpec.describe Season, type: :model do
  describe "validations" do
    let(:title) { "First Season" }
    let(:original_title) { "First Season" }
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
        title: title,
        original_title: original_title,
        year: year,
        number: number,
        tv_show: tv_show
      )
    end

    it "is valid with all required attributes" do
      expect(season).to be_valid
    end

    context "when title is not present" do
      let(:title) { nil }

      it "is invalid" do
        expect(season).not_to be_valid
      end
    end

    context "when original title is not present" do
      let(:original_title) { nil }

      it "is invalid" do
        expect(season).not_to be_valid
      end
    end

    context "when year is not present" do
      let(:year) { nil }

      it "is invalid" do
        expect(season).not_to be_valid
      end
    end

    context "when number is not present" do
      let(:number) { nil }
      it "is invalid" do
        expect(season).not_to be_valid
      end
    end

    context "when tv show is not present" do
      let(:tv_show) { nil }
      it "is invalid" do
        expect(season).not_to be_valid
      end
    end

    context "when season number is duplicated on the same tv show" do
      let(:tv_show) do
        TvShow.create!(
          title: "Malcom in the Middle",
          original_title: "Malcom in the Middle",
          year: 2000
        )
      end

      before do
        Season.create!(
          title: "First Season",
          original_title: "First Season",
          year: 2000,
          number: 1,
          tv_show: tv_show
        )
      end
      it "is invalid" do
        expect(season).not_to be_valid
      end
    end

    context "when a different tv show has the same season number" do
      let(:tv_show) do
        TvShow.create!(
          title: "Malcom in the Middle",
          original_title: "Malcom in the Middle",
          year: 2000
        )
      end

      let(:other_tv_show) do
        TvShow.create!(
          title: "CSI: Las Vegas",
          original_title: "CSI: Las Vegas",
          year: 2000
        )
      end

      let(:season) do
        Season.new(
          title: title,
          original_title: original_title,
          year: year,
          number: number,
          tv_show: other_tv_show
        )
      end

      before do
        Season.create!(
          title: "First Season",
          original_title: "First Season",
          year: 2000,
          number: 1,
          tv_show: tv_show
        )
      end
      it "is valid" do
        expect(season).to be_valid
      end
    end
  end
end
