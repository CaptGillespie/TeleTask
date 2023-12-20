class Appointment < ApplicationRecord
    belongs_to :doctor
    belongs_to :patient

    #Validations
    validates :name, presence: true
    validates :phone, presence: true

    enum status: [ :pending, :confirmed, :rejected ]

    def confirm!
        self.status = "confirmed"
        self.save!
    end

    def reject!
        self.status = "rejected"
        self.save!
    end

    def notify_doctor(force = true)
        @doctor = Doctor.find(self.doctor[:user_id])
        message = "You have a new appointment request from #{self.name} for #{self.doctor.description}:
        '#{self.message}'
        Reply [accept] or [reject]."
        @host.send_message_via_sms(message)
    end

    def notify_patient
        @patient = Patient.find_by(phone: self.phone)

        if self.status_changed? && (self.status == "confirmed" || self.status == "rejected")
            message = "Your recent appointment request for #{self.doctor.description} was #{self.status}."
            @patient.send_message_via_sms(message)
        end
    end



end
