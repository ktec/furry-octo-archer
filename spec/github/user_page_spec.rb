require "spec_helper"

describe Github::PageTypes::UserPage do
  let(:page) {
    f = File.open("./fixtures/user_page.html")
    doc = Nokogiri::HTML(f)
    f.close
    doc
  }
  subject { described_class.new(page) }

  specify { expect(subject.github_id).to eq(190846) }
  specify { expect(subject.username).to eq("RubyLouvre") }
  specify { expect(subject.worksfor).to eq("qunar.com") }
  specify { expect(subject.location).to eq("China") }
  specify { expect(subject.join_date).to eq("2010-01-27T12:26:59Z") }
  specify { expect(subject.email).to eq("cheng19840218@gmail.com") }
  specify { expect(subject.followers).to eq(1800) }
  specify { expect(subject.following).to eq(24) }
  specify { expect(subject.stars).to eq(150) }
  specify { expect(subject.total_public_contributions_last_year).to eq(2599) }

end
