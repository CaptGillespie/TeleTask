TeleTask Overview

Developed as a proof of concept app, connecting Doctors & Patients via Twilio SMS API
Using ActiveAdmin && SQL DB
Devise for login

Dashboard contains two menu items: Appointments & Doctors:

  1 - Doctors is a show all grid of records in tblDoctors
  ![image](https://github.com/CaptGillespie/TeleTask/assets/51388344/40943ed6-f494-45ca-81b7-563ebcadca43)

  2 - Appointments is a scoped-collection, showing only the Appointments (tblAppointments) for the logged in User
  A callback function in app/models/appointment.rb sends text to the UI-selected Doctor's phone number after successful Appointment record creation





Two ways for users (patients) to request an Appointment
  both methods use a callback function to notify the Doctor's office of a new Appointment Request:
  ![image](https://github.com/CaptGillespie/TeleTask/assets/51388344/edfbc431-1562-4ed2-8d19-f51c944f3d9f)


  1 - The standard Grid [New Appointment] btn -
      ![image](https://github.com/CaptGillespie/TeleTask/assets/51388344/8ce94a7a-1481-47f4-83a0-03a93d3ba2ab)


  2 - From the individual Doctor's View Page, a sidebar form allows Appointment Requests to be created and sent
      
![image](https://github.com/CaptGillespie/TeleTask/assets/51388344/f549ed58-2e1b-4ca3-9dd9-db704515ed7b)



      
All newly created Appointments have a db status of 'Pending', and depending on the Doctor's response, 
subsequent functions can update that record's status and send status changes back to patients. 
Though note, at this time Twilio and/or my cell carrier is blocking my outgoing texts as possible spam.
TODO: sort out Twilio, maybe it's an Opt-in setting?
