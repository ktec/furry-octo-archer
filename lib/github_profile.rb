class GithubProfile
  def initialize(doc)
    @doc = doc
  end

  def valid?
    unless github_id.empty? &&
           fullname.empty? &&
           username.empty? &&
           worksfor.empty? &&
           email.empty? &&
           homelocation.empty? &&
           join_date.empty?
      true
    end
  end

  def attributes
    {
      github_id: github_id,
      fullname: fullname,
      username: username,
      worksfor: worksfor,
      email: email,
      location: homelocation,
      join_date: join_date,
    }
  end

  def details
    "github_id:#{github_id}\t" \
    "fullname:#{fullname}\t" \
    "username:#{username}\t" \
    "worksfor:#{worksfor}\t" \
    "email:#{email}\t" \
    "location:#{homelocation}\t" \
    "join_date:#{join_date}\n"
  end

  def github_id
    begin
      @doc.css("[class='avatar']").first["data-user"]
    rescue
      ""
    end
  end

  def fullname
    begin
      @doc.css("[class='vcard-fullname']").text
    rescue
      ""
    end
  end

  def username
    begin
      @doc.css("[class='vcard-username']").text
    rescue
      ""
    end
  end

  def homelocation
    begin
      @doc.css("[class='vcard-detail'][itemprop='homeLocation']").text
    rescue
      ""
    end
  end

  def worksfor
    begin
      @doc.css("[class='vcard-detail'][itemprop='worksFor']").text
    rescue
      ""
    end
  end

  def email
    begin
      @doc.css("[class='email']").text
    rescue
      ""
    end
  end

  def join_date
    begin
      @doc.css("[class='join-date']").first["datetime"]
    rescue
      ""
    end
  end

end
