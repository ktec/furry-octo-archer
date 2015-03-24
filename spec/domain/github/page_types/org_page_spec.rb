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
        it { expect(subject[:projects]).to eq([
          {:language=>"Clojure",
          :name=>"kata-edn-to-json",
          :description=>"",
          :stars=>"0",
          :forks=>"0"},
          {:language=>"",
          :name=>"authorized_keys",
          :description=>"You know what this is. Pairing is sharing.",
          :stars=>"0",
          :forks=>"1"},
          {:language=>"",
          :name=>"emacs-cheat-sheet",
          :description=>
           "A community maintained cheat sheet to help Clojure developers get started with Emacs.",
          :stars=>"1",
          :forks=>"0"},
          {:language=>"Clojure",
          :name=>"surlybird",
          :description=>"REST endpoints for the project openbike mobile clients.",
          :stars=>"3",
          :forks=>"0"},
          {:language=>"Clojure",
          :name=>"ten-things",
          :description=>"Ten (or more) Clojure things you should know",
          :stars=>"0",
          :forks=>"0"},
          {:language=>"Clojure",
          :name=>"lein-validate",
          :description=>"An example of writing a leiningen plugin",
          :stars=>"0",
          :forks=>"0"},
          {:language=>"Clojure",
          :name=>"energyanalyzer",
          :description=>"Analysis code for NREL energy usage data sets.",
          :stars=>"3",
          :forks=>"4"}
          ]) }




      end
    end
  end
end
