require "spec_helper"

module Domain
  module Github
    module PageTypes
      describe OrgPage do
        let(:html_doc) {
          file = File.open("./fixtures/org_page.html")
          doc = Nokogiri::HTML(file)
          file.close
          doc
        }

        subject { described_class.new(html_doc).attributes }

        it { expect(subject[:item_type]).to eq('http://schema.org/Organization')}
        it { expect(subject[:email]).to eq("denofclojure@gmail.com") }
        it { expect(subject[:own_projects]).to eq([
          {
            :language=>"Clojure",
            :name=>"kata-edn-to-json",
            :description=>"",
            :stars=>0,
            :forks=>0
          },
          {
            :language=>"Clojure",
            :name=>"energyanalyzer",
            :description=>"Analysis code for NREL energy usage data sets.",
            :stars=>3,
            :forks=>4
          }
          ])
        }

        it { expect(subject[:forked_projects]).to eq([
          {
            :language=>"Java",
            :name=>"OpenBike-API",
            :description=>"An open source multi-modal trip planner",
            :stars=>1,
            :forks=>318,
            :forked_from=>"/colorado-code-for-communities/OpenBike-API",
            :updated=>"2013-03-25T19:39:11Z"
          },
          {
            :language=>"Clojure",
            :name=>"barista",
            :description=>"Programming exercise for the Denver Clojure Users Group.",
            :stars=>0,
            :forks=>2,
            :forked_from=>"/zk/barista",
            :updated=>"2010-09-29T06:38:57Z"
          }
          ])
        }


        it { expect(subject[:members]).to eq([
          { id: 1381061, username: "@64BitChris" },
          ])
        }
      end
    end
  end
end
