require 'rails_helper'

RSpec.describe List, type: :model do
  describe "validations" do
    let(:name) { "Top 10" }

    let(:list) do
      List.new(name: name)
    end

    it "is valid with all required attributes" do
      expect(list).to be_valid
    end

    context "when name is not present" do
      let(:name) { nil }

      it "is invalid" do
        expect(list).not_to be_valid
      end
    end
  end
end
