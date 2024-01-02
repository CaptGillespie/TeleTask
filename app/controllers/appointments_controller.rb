class AppointmentsController < ApplicationController
  require 'twilio-ruby'

  def getDoctor_Phone(key)
    phone = ActiveRecord::Base.connection.exec_query(
      "Select Phone from tblDoctor WHERE PKey = '#{key}'").rows
    phone.flatten![0] if !phone.empty?
  end

  def getDoctor_Name(key)
    name = ActiveRecord::Base.connection.exec_query(
      "Select Name from tblDoctor WHERE PKey = '#{key}'").rows
      name.flatten![0] if !name.empty?
  end

  def send_Request
    #sends texts to doctor's office with requested appointment's patient/datetime 

    #Print would-be-text sent
    p "***************************************************************************"
    phone_number = getDoctor_Phone(params[:DoctorID])
    doctor_name = getDoctor_Name(params[:DoctorID])

    p 'To: ' + phone_number 
    p "Patient: #{current_admin_user.Name} requests an appointment with Doctor #{doctor_name} on #{params[:ApptDate]} at #{params[:ApptTime]}"
    p "***************************************************************************"

    #TODO - configure Twilio Opt-ins - Outgoing message is being blocked as 'spam'
    @app_number = ENV['TWILIO_NUMBER']
        @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
        phone_number = getDoctor_Phone(params[:DoctorID])
        doctor_name = getDoctor_Name(params[:DoctorID])
        message = "Patient: #{current_admin_user.Name} requests an appointment with Doctor #{doctor_name} on #{params[:apptDate]} at #{params[:apptTime]}"
        sms_message = @client.api.account.messages.create(
            from: @app_number,
            to: phone_number,
            body: message,
        )
  end



  def doctor_Appt
    #Create a new Appointment
    @doctorName = getDoctor_Name(params[:DoctorID])
    @aptDate = (params[:ApptDate].to_datetime + Time.parse(params[:ApptTime]).seconds_since_midnight.seconds).strftime("%Y-%m-%d %H:%M:%S")
    insertrecord = ActiveRecord::Base.connection.exec_query("INSERT INTO tblAppointments VALUES(#{current_admin_user.id}, '#{current_admin_user.Name}', #{params[:DoctorID]}, '#{@doctorName}', 0, 'Pending', '#{@aptDate}')").rows
    flash[:notice] = "Appointment request has been sent."
    
    #Sent text to the Doctor's Office
      send_Request()
      redirect_to admin_doctor_url
  end


  def accept_or_reject
    incoming = Sanitize.clean(params[:From]).gsub(/^\+\d/, '')
    sms_input = params[:Body].downcase
    begin
      @host = Patient.find_by(phone: incoming)
      @appointments = @host.pending_appointment

      if sms_input == "accept" || sms_input == "yes"
        @appointments.confirm!
      else
        @appointments.reject!
      end

      @host.check_for_appointments_pending

      sms_reponse = "You have successfully #{@appointment.status} the appointment."
      respond(sms_reponse)
    rescue
      sms_reponse = "Sorry, it looks like you don't have any appointments to respond to."
      respond(sms_reponse)
    end
  end

  private
  # Send an SMS back to the Patient
  # def respond(message)
  #   response = Twilio::TwiML::Response.new do |r|
  #     r.Message message
  #   end
  #   render text: response.text
  # end

  
end
