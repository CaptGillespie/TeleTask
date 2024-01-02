class Appointment < ApplicationRecord
    self.table_name = "tblAppointments"
    has_one :doctor, class_name: "Doctor", foreign_key: "DoctorID", primary_key: "PKey"
    has_one :patient, class_name: "Patient", foreign_key: "PatientID", primary_key: "PatientID"

    def display_name
        "Appointment for #{self.PatientName} with Doctor #{self.Doctor}"
    end

    #Piecemealing date + time from different UI selectors, so using accessors to allow 
    attr_reader :ApptTime
    attr_writer :ApptTime
    
    validates :DoctorID, presence: true

    #Lookup / Helper ()'s ====================================================================================
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

      

    #Callbacks==============================================================================================
    before_create :set_AppointmentValues
    after_create :notify_Doctor

    def set_AppointmentValues
        #Sets Doctor Name based on dropdown, which was displaying name but storing Pkey
        doc = Doctor.find(self.DoctorID)
        self.Doctor = doc.Name
        #Combines Appointment date & time to SQL datetime obj
        self.ApptDate = self.ApptDate.to_datetime + Time.parse(self.ApptTime).seconds_since_midnight.seconds
        self.Status = 'Pending'
    end


    def notify_Doctor
        
        phone_number = getDoctor_Phone(self.DoctorID)
        doctor_name = getDoctor_Name(self.DoctorID)
        apptDateFormat = self.ApptDate.strftime('%m-%d-%Y')

        #Print would-be-sent text
        p "***************************************************************************"
        p 'To: ' + phone_number 
        p "Patient: #{self.PatientName} requests an appointment with Doctor #{doctor_name} on #{apptDateFormat} at #{self.ApptTime}"
        p "***************************************************************************"

        #Twilio API
        @app_number = ENV['TWILIO_NUMBER']
        @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
        phone_number = "+#{country_code}#{self.phone}"
        sms_message = @client.api.account.messages.create(
            from: @app_number,
            to: phone_number,
            body: message,
        )
    end
   


    #========================================================================================================
    #TODO - Configure Twilio, my texts are being blocked
    #Without a return object to test, the below code is speculative:


    #Depending on Doctor's return text:
    #Follow up functions can update Appointment dbo fields
    def confirm!
        self.status = "Confirmed"
        self.Confirmed = 1
        self.save!
    end

    def reject!
        self.status = "Rejected"
        self.save!
    end

    def notify_patient
        #Notify patient that the Appointment status has changed
        @patient = Patient.find_by(phone: self.phone)

        if self.status_changed? && (self.status == "confirmed" || self.status == "rejected")
            message = "Your recent appointment request for #{self.doctor} is #{self.status}."
            @patient.send_message_via_sms(message)
        end
    end



end
