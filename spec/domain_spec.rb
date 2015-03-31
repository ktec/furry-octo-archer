require "spec_helper"

describe TestDomain do
  subject { described_class }
  describe ".page_types" do
    it "returns an enum of classes" do
      expect(subject.page_types.class).to be(Enumerator)
      expect(subject.page_types).to match_array([Type2,Type1])
    end
  end
  describe ".process_page" do
    let(:test) { Object.new() }
    it "calls valid on each class" do
      expect_any_instance_of(Type1).to receive(:valid?)
      expect_any_instance_of(Type2).to receive(:valid?)
      subject.process_page(test)
    end
    it "returns no template found" do
      expect(subject.process_page(test)).to eq("No template found")
    end
  end
  describe ".process_template" do
  end
end
