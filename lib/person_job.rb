class PersonJob < Struct.new(:person_id, :create_google_email, :create_twiki_account, :create_yammer_account)
  def perform
#    Delayed::Worker.logger.debug("person_id #{person_id}, create_google_email #{create_google_email}, create_twiki_account #{create_google_email}")

    person = Person.find(person_id)
    error_message = ""
    if create_google_email && person.google_created.blank?
       password = 'just4now' + Time.now.to_f.to_s[-4,4] # just4now0428
       status = person.create_google_email(password)
       if status.is_a?(String)
         error_message += "Google account not created. " + status + "</br></br>"
       else
         PersonMailer.deliver_welcome_email([person.personal_email, person.email], person, password)
       end
    end
    if create_twiki_account && person.twiki_created.blank?
      status = person.create_twiki_account
      error_message +=  'TWiki account was not created.<br/></br>' unless status
      status = person.reset_twiki_password
      error_message +=  'TWiki account password was not reset.</br>' unless status
    end

    if create_yammer_account && person.yammer_created.blank?
      status = person.create_yammer_account
      error_message +=  'Yammer account was not created.<br/></br>' unless status
    end


    if(!error_message.blank?)
 #     Delayed::Worker.logger.debug(error_message)
      puts error_message
      message = error_message
      GenericMailer.deliver_email(
        :to => ["help@sv.cmu.edu", "todd.sedano@sv.cmu.edu"],
        :subject => "PersonJob had an error on person id = #{person.id}",
        :message => message,
        :url_label => "Show which person",
        :url => "http://rails.sv.cmu.edu/people/#{person.id}" #+ person_path(person)
      )
    end
  end



  private
  def send_email(personal_email, sv_email, message)
           PersonMailer.deliver_email(
             :bcc => "todd.sedano@sv.cmu.edu",
             :to => personal_email,
             :from => "CMU-SV Official Communication <help@sv.cmu.edu>",
             :subject => "Welcome to Carnegie Mellon University Silicon Valley (" + sv_email + ")",
             :message => message,
#             :url_label => "Check your email",
#             :url => "http://mail.google.com/a/west.cmu.edu/#inbox",
             :cc => "help@sv.cmu.edu"
            )
  end


end