TeleTask Overview

Developed as a proof of concept app, connecting Doctors & Patients via Twilio SMS API
Using ActiveAdmin && SQL DB
Devise for login

Dashboard contains two menu items: Appointments & Doctors:

  1 - Doctors is a show all grid of records in tblDoctors
  ![image](https://github.com/CaptGillespie/TeleTask/assets/51388344/40943ed6-f494-45ca-81b7-563ebcadca43)

  2 - Appointments is a scoped-collection, showing only the Appointments (tblAppointments) for the logged in User

Two ways for users to request an Appointment
  1 - The standard Grid [New Appointment] btn -
  
      ![image](https://github.com/CaptGillespie/TeleTask/assets/51388344/5bc9de54-24cd-42aa-8d56-b5e75c6dce13)

      A callback function in app/models/appointment.rb sends text to the UI-selected Doctor's phone number after successful Appointment record creation
      ![image](https://github.com/CaptGillespie/TeleTask/assets/51388344/5b168f15-041b-47d6-8f1c-987d7b73ba56)
      
  2 - From the individual Doctor's View Page, a sidebar form allows Appointment Requests to be created and sent
      ![image](https://github.com/CaptGillespie/TeleTask/assets/51388344/a648d792-8efc-45e6-aa4d-084b0b33db5f)

All newly created Appointments have a db status of 'Pending', and depending on the Doctor's response, 
subsequent functions can update that record's status and send status changes back to patients. 
Though note, at this time Twilio and/or my cell carrier is blocking my outgoing texts as possible spam.
TODO: sort out Twilio, maybe it's an Opt-in setting?
