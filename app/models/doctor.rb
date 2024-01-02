class Doctor < ApplicationRecord
    self.table_name = "tblDoctor"
    
    has_many :appointments
    has_many :patients, through: :appointments 

    def index
        @doctors = Doctor.all
    end

end

