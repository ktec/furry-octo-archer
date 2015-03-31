require "spec_helper"

describe Github::PageTypes::OrgPage do
  let(:page) {
    f = File.open("./fixtures/org_page.html")
    doc = Nokogiri::HTML(f)
    f.close
    doc
  }
  subject { described_class.new(page) }

  specify { expect(subject.item_type).to eq('http://schema.org/Organization') }
  specify { expect(subject.github_id).to eq(2722525) }
  specify { expect(subject.email).to eq("denofclojure@gmail.com") }
  specify { expect(subject.own_projects).to eq([
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

  specify { expect(subject.forked_projects).to eq([
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

  specify { expect(subject.members).to eq([
    { id: 1381061, username: "@64BitChris" },
    ])
  }


end
