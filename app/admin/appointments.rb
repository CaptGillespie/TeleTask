ActiveAdmin.register Appointment do

  permit_params :Doctor,:PatientName, :PatientID, :DoctorID, :ApptTime, :ApptDate

  controller do
    def scoped_collection
      Appointment.where("PatientID = #{current_admin_user.id}")
    end
  end

  form do |f|
    f.inputs "New Appointment" do
      f.hidden_field :PatientID, value: current_admin_user.id 
      f.hidden_field :Doctor
      f.input :PatientName, label: 'Patient Name', as: :string, :input_html => { value: current_admin_user.Name, readonly: true } 
      f.input :DoctorID, label: 'Doctor', as: :select, collection: Doctor.all.pluck(:Name, :PKey), input_html: { style: 'text-align: center; padding: 5px; width: 25%;' }
      f.label 'Preferred Appointment Date and Time', style: 'text-align: center; padding: 10px;'
      f.date_field :ApptDate, :value => Time.now.strftime('%Y-%m-%d'), style: 'text-align: center; padding: 10px; width: 25%;'
      f.time_field :ApptTime, :value => Time.now, style: 'text-align: center; padding: 10px; width: 25%;'
    end
    f.actions
  end

 

  
end
