require 'net/ldap'

module WilliamsCollegeLdap
  
  # Code currently assumes username is unique across faculty/staff/students/"people"

  LDAP_PORT = 636
  LDAP_HOST = 'nds1.williams.edu'
  LDAP_O = 'williams'

  def self.authenticate(username, password)
    return false if !password or password.empty?
    c = Net::LDAP.new(:host => LDAP_HOST, :port => LDAP_PORT, :encryption => :simple_tls)
    auth = false
    begin
      # the get_directory_attributes call should return something like ["cn=cwade,ou=STAFF,o=williams"] 
      # if the user is found
      if auth_string = self.get_directory_attributes(username, ["dn"]) and auth_string.first.present?
        c.auth(auth_string, password)
        auth = true if c.bind
      end
    rescue
      raise "Error connecting to server"
    end
    return auth
  end

  def self.get_email(username)
    r = directory_search(username)
    if r.empty?
      return false
    elsif r.size > 1
      raise "More than one user found for username #{username}"
    else
      r.first.mail.first
    end
  end
  
  def self.get_directory_information(username)
    result = get_directory_attributes(username, ['mail', 'givenname', 'sn', 'wmsaffiliationfamily', 'wmsclass'])
    # We only return Williams class year for students - faculty or employees who are also alums
    # shouldn't have this filled in
    if result
      return [result[0], result[1], result[2], result[3] == "S" ? result[4] : '']
    else
      return false
    end
  end
  
  def self.get_directory_attributes(username, attributes)
    r = directory_search(username)
    if r.empty?
      return false
    elsif r.size > 1
      raise "More than one user found for username #{username}"
    else
      result = r.first
      attributes.collect do |a|
        attrib = result.respond_to?(a) ? result.send(a) : ''
        attrib.kind_of?(Array) ? attrib.join(', ') : attrib
      end
    end
  end
  
  def self.directory_search(username)
    filter = Net::LDAP::Filter.eq('uid', username)
    c = Net::LDAP.new(:host => LDAP_HOST, :port => LDAP_PORT, :encryption => :simple_tls)
    c.search(:base => "o=#{LDAP_O}", :filter => filter)
  end

end
