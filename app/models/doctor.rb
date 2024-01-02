class Doctor < ApplicationRecord
    self.table_name = "tblDoctor"
    self.primary_key = :PKey
    
    has_many :appointments
    has_many :patients, through: :appointments 

    def index
        @doctors = Doctor.all
    end

    def display_name
        "Doctor #{self.Name} "
    end

end

