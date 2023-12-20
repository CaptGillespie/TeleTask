class Patient < ApplicationRecord
    has_many :doctors
    has_many :appointments, through: :doctors


    def send_message_via_sms(message)
        @app_number = ENV['TWILIO_NUMBER']
        @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
        phone_number = "+#{country_code}#{self.phone}"
        sms_message = @client.account.messages.create(
            from: @app_number,
            to: phone_number,
            body: message,
        )
    end
    
    def check_for_appointments_pending
        if pending_appointment
            pending_appointment.notify_host(true)
        end
    end

    def pending_appointment
        self.appointments.where(status: "pending").first
    end

    def pending_appointments
        self.appointments.where(status: "pending")
    end
    
end
