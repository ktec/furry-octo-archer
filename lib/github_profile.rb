class GithubProfile

  def initialize(doc)
    @doc = doc
    @attributes = {
      github_id: %{css("[class='avatar']").first['data-user']},
      fullname: %{css("[class='vcard-fullname']").text},
      username: %{css("[class='vcard-username']").text},
      worksfor: %{css("[class='vcard-detail'][itemprop='worksFor']").text},
      email: %{css("[class='email']").text},
      location: %{css("[class='vcard-detail'][itemprop='homeLocation']").text},
      join_date: %{css("[class='join-date']").first["datetime"]},
    }
  end

  def valid?
    @attributes.map{|k,v| self.send(k).empty? if self.send(k) }.include?(false)
  end

  def attributes
    @attributes.each_with_object({}) {|(k,v),o|
      o[k.to_sym]=safe_get_attribute(k)
    }
  end

  def serialize
    attributes.map{|k,v| "#{k}: #{v}"}.join("\t") + "\n"
  end

  def safe_get_attribute(attr)
    begin
      @doc.instance_eval(@attributes[attr])
    rescue
      ""
    end
  end

  def method_missing(method_sym, *arguments, &block)
    if @attributes.include?(method_sym)
      safe_get_attribute(method_sym)
    else
      super
    end
  end

end
