class Pour
	@place_rate
	@pour_height
	@pressure

	def initialize
		#load default values
		@chem_coef = 1.0
		@weight_coef = 1.0
		@conc_weight = 145.0
		@conc_temp = 90.0
		@deflect_allow = 180 #inverse of actual
		@wind_load = 15.0
		@pour_type = "WALL"
		@form_one_time = true
		@wet_cond = false
	end
	
	#how fast concrete is poured affects pressure
	def set_placement_rate
		puts "Enter the rate concrete will be placed in vertical linear feet per hour:"
		@place_rate = gets.chomp.to_f
	end	
	
	#height of wall affects pressure
	def set_max_height
		puts "Enter maximum height of pour in vertical linear feet:"
		@pour_height = gets.chomp.to_f
	end
	
	#formulas are different for walls vs. columns
	def set_pour_type
		puts "1) Column Pour    2) Wall pour (default)"
		puts "Enter NUMBER of type of pour"
		pour_choice = gets.chomp.to_i
		if pour_choice == 1 then
			@pour_type = "COLUMN"
		elsif pour_choice == 2 then
			@pour_type = "WALL"
		else
			puts "I didn't recognize that choice"
		end
	end
		
	#get common concrete type and translate into chemical coefficient value
	def set_chem_coef
		puts "(1) Type I,II,III concrete (default)"
		puts "(2) Type I,II, III with retarder add"
		puts "(3) Other type with less 70% slag or 40% fly ash"
		puts "(4) Other type with retarder add"
		puts "(5) Other with more than 70% slag or 40% fly ash"
		puts "Enter concrete type by NUMBER:" 
		conc_type = gets.chomp.to_i
		case conc_type
		when 1
			@chem_coef = 1.0
		when 2, 3
			@chem_coef = 1.2
		when 4, 5
			@chem_coef = 1.4
		else
			puts "That's an invalid response. Try again."
		end
	end	
	
	
	def set_weight_coef
		puts "Enter weight of concrete in lbs per cf"
		@conc_weight = gets.chomp.to_f
		if @conc_weight < 140.0 then
			temp_chem = ((@conc_weight / 145) + 1) * 0.5
			if temp_chem < 0.8 then
				@weight_coef = 0.8
			else
				@weight_coef = temp_chem
			end
		elsif @conc_weight >= 140 && @conc_weight < 150 then
			@weight_coef = 1.0
		else
			@weight_coef = @conc_weight / 145
		end
	end
	
	def set_temp
		puts " Enter Concrete temp in (F):"
		@conc_temp = gets.chomp.to_f
	end
	
	def set_deflection
		puts " 1) 1/180   2) 1/240    3) 1/360"
		puts "Enter NUMBER for allowable deflection:"
		deflect_choice = gets.chomp.to_i
		case deflect_choice
		when 1
			@deflect_allow = 180
		when 2
			@deflect_allow = 240
		when 3
			@deflect_allow = 360
		else
			puts "That's an invalid response. Try Again"
		end
	end
	
	def set_wind_load
		puts "Enter expected wind load in lbs per sf(but 15 psf is minimum):"
		temp_wind = gets.chomp
		if temp_wind.to_f < 15.0 then
			puts "resetting to minimum - 15 psf"
			@wind_load = 15.0
		else
			@wind_load = temp_wind.to_f
		end
	end
	
	def set_form_use
		@form_one_time = !@form_one_time
		puts "Changing One-time Form use to: " + @form_one_time.to_s
	end
	
	def set_wet_cond
		@wet_cond = !@wet_cond
		puts "Changing Wet Condiiton to: " + @wet_cond.to_s
	end
	
	def calc_pressure
		if @pour_type == "COLUMN" then
			p = 9000 * @place_rate / @conc_temp #ACI 347 formula 2001
			p = p + 150
			if p <= 3000 then
				p = p * @weight_coef * @chem_coef
			else
				p = @conc_weight * @pour_height
			end
		else
			p = 2800 * @place_rate  # ACI 347 formula 2001
			p = p + 43000
			p = p / @conc_temp
			p = p + 150
			if p <= 2000 then
				p = p * @weight_coef * @chem_coef
			else
				p = @conc_weight * @pour_height
			end
		end
		if p < 600 * @weight_coef then
			p = 600 * @weight_coef
		end
		@pressure = p
	end
			
	#debugging display
	def display
		system "clear" or system "cls"
		puts "                     CURRENT CONCRETE POUR VALUES"
		puts "------------------------------------------------------------------------"
		puts "| 1) CONCRETE WEIGHT: " + @conc_weight.to_s + " pcf       | 2) CONCRETE TEMP: " + @conc_temp.to_s + " deg (F) |"
		puts "| 3) DEFLECTION ALLOWANCE: 1/" + @deflect_allow.to_s + "      | 4) WIND LOAD: " + @wind_load.to_s + " psf         |"
		puts "| 5) USE FORM ONLY ONCE?: " + @form_one_time.to_s + "        | 6) WET CONDITION: " + @wet_cond.to_s + "        |"
		puts "| 7) PLACEMENT RATE: " + @place_rate.to_s + " VLF/HR      | 8) MAXIMUM HEIGHT: " + @pour_height.to_s + " VLF    |"
		puts "| 9) TYPE OF POUR: " + @pour_type + "                                                |"
		puts "------------------------------------------------------------------------"
		puts "| CHEM COEF: " + @chem_coef.to_s + "                      | WEIGHT COEF: " + @weight_coef.to_s + "        |"
		puts "| PRESSURE: " + @pressure.to_s + " psf"
		puts "   "
	end
end


puts "Welcom to form board calculator."
puts "First, we need to get some basic information."
puts ""

p1 = Pour.new
p1.set_chem_coef
p1.set_placement_rate
p1.set_max_height
p1.set_pour_type
p1.calc_pressure
p1.display

