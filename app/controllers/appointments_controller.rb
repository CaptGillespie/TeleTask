class AppointmentsController < ApplicationController

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
