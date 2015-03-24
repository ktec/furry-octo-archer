require "spec_helper"

module Domain
  module Github
    module PageTypes
      describe UserPage do
        let(:html_doc) {
          f = File.open("./fixtures/user_page.html")
          doc = Nokogiri::XML(f)
          f.close
          doc
        }

        subject { described_class.new(html_doc).attributes }

        it { expect(subject[:github_id]).to eq(190846) }
        it { expect(subject[:username]).to eq("RubyLouvre") }
        it { expect(subject[:worksfor]).to eq("qunar.com") }
        it { expect(subject[:location]).to eq("China") }
        it { expect(subject[:join_date]).to eq("2010-01-27T12:26:59Z") }
        it { expect(subject[:email]).to eq("cheng19840218@gmail.com") }
        it { expect(subject[:followers]).to eq(1800) }
        it { expect(subject[:following]).to eq(24) }
        it { expect(subject[:stars]).to eq(150) }
        it { expect(subject[:total_public_contributions_last_year]).to eq(2599) }

      end
    end
  end
end
