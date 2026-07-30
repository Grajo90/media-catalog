require 'rails_helper'

RSpec.describe TvShow, type: :model do
  describe "validations" do
    let(:title) { "Malcom in the Middle" }
    let(:original_title) { "Malcom in the Middle" }
    let(:year) { 2000 }

    let(:tv_show) do
      TvShow.new(
        title: title,
        original_title: original_title,
        year: year
      )
    end

    it "is valid with all required attributes" do
      expect(tv_show).to be_valid
    end

    context "when title is not present" do
      let(:title) { nil }

      it "is invalid" do
        expect(tv_show).not_to be_valid
      end
    end

    context "when original title is not present" do
      let(:original_title) { nil }

      it "is invalid" do
        expect(tv_show).not_to be_valid
      end
    end

    context "when year is not present" do
      let(:year) { nil }

      it "is invalid" do
        expect(tv_show).not_to be_valid
      end
    end
  end
end
