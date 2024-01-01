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

  def new_appt_req
    #on (POST :/ route) aka New Appointment form submit, sends texts to doctor's office with requested appointment patient/datetime 
    #TODO add logged-in users as 'patient' name
    loggedUser = 'Sean'

    #Print would-be-text sent
    #In a real-world app, we'd want to log it somewhere too for posterity
    p "***************************************************************************"
    phone_number = getDoctor_Phone(params[:doctorKey])
    doctor_name = getDoctor_Name(params[:doctorKey])
    p "Patient: #{loggedUser} requests an appointment with Doctor #{doctor_name} on #{params[:apptDate]} at #{params[:apptTime]}"
    p "***************************************************************************"

    #TODO - configure Twilio
    @app_number = ENV['TWILIO_NUMBER']
        @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
        phone_number = getDoctor_Phone(params[:doctorKey])
        doctor_name = getDoctor_Name(params[:doctorKey])
        message = "Patient: #{loggedUser} requests an appointment with Doctor #{doctor_name} on #{params[:apptDate]} at #{params[:apptTime]}"
        sms_message = @client.account.messages.create(
            from: @app_number,
            to: phone_number,
            body: message,
        )
  end











  def new
    @appointment = Appointment.new
  end

  def create
    @appointment = Appointment.new(appointment_params)

    if @appointment.save
      flash[:notice] = "Appointment request has been sent."
      @appointment.notify_host
      redirect_to @doctor
    else
      flast[:danger] = @appointment.errors
    end
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
  def respond(message)
    response = Twilio::TwiML::Response.new do |r|
      r.Message message
    end
    render text: response.text
  end

  # Limit incoming params.
  def appointment_params
    params.require(:appointment).permit(:name, :phone, :message)
  end
end
