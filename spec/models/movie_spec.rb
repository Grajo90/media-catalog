require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe "validations" do
    let(:title) { "Shrek" }
    let(:original_title) { "Shrek" }
    let(:year) { 2001 }

    let(:movie) do
      Movie.new(
        title: title,
        original_title: original_title,
        year: year
      )
    end

    it "is valid with all required attributes" do
      expect(movie).to be_valid
    end

    context "when title is not present" do
      let(:title) { nil }

      it "is invalid" do
        expect(movie).not_to be_valid
      end
    end

    context "when original title is not present" do
      let(:original_title) { nil }

      it "is invalid" do
        expect(movie).not_to be_valid
      end
    end

    context "when year is not present" do
      let(:year) { nil }

      it "is invalid" do
        expect(movie).not_to be_valid
      end
    end
  end
end
