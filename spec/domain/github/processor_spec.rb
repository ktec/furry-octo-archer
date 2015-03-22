require "spec_helper"

module Domain
  module Github
    describe Processor do
      subject { Processor.new("www.example.com") }
      it "downloads all the things" do
        subject.run
      end
    end
  end
end
