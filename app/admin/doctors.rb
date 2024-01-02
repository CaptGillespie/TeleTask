ActiveAdmin.register Doctor do


  #Command
  sidebar :RequestAppointment, only: :show do |f|
    render "/appointments/requestNew", :locals => { :doctorKey => resource.PKey }
  end
  
end
