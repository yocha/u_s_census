require 'open-uri'
require 'yaml'

require "u_s_census/version"

module USCensus
  HOST = "http://thedataweb.rm.census.gov/data/2010/"
	# FIPS geography code
	STATES = {
		"Alabama"=>"01","Alaska"=>"02","Arizona"=>"04","Arkansas"=>"05","California"=>"06","Colorado"=>"08","Connecticut"=>"09","Delaware"=>"10","District of Columbia"=>"11","Florida"=>"12","Georgia"=>"13","Hawaii"=>"15","Idaho"=>"16","Illinois"=>"17","Indiana"=>"18","Iowa"=>"19","Kansas"=>"20","Kentucky"=>"21","Louisiana"=>"22","Maine"=>"23","Maryland"=>"24","Massachusetts"=>"25","Michigan"=>"26","Minnesota"=>"27","Mississippi"=>"28","Missouri"=>"29","Montana"=>"30","Nebraska"=>"31" ,"Nevada"=>"32","New Hampshire"=>"33","New Jersey"=>"34","New Mexico"=>"35","New York"=>"36","North Carolina"=>"37","North Dakota"=>"38","Ohio"=>"39","Oklahoma" =>"40","Oregon"=>"41","Pennsylvania"=>"42","Rhode Island"=>"44","South Carolina"=>"45","South Dakota"=>"46","Tennessee"=>"47","Texas"=>"48","Utah"=>"49","Vermont"=>"50","Virginia"=>"51","Washington"=>"53","West Virginia"=>"54","Wisconsin"=>"55","Wyoming"=>"56","Puerto Rico"=>"72"
	}

	# Get 2010 Census SF1 data for the states by using
	# <tt>census_summary_2010</tt> and pass it key,  list of states (FIPS codes or
	# state names) and api_variables
	# (http://www.census.gov/developers/data/sf1.xml).
	# This will return array of hashes.
	#
	# <tt>USCensus::census_summary_2010(key, ["California"], ["P0010001"])</tt>
	#
	def self.census_summary_2010(key, states = "*", api_variables = ["P0010001"])
		states = fips_codes(states)
		api_variables = api_variables.join(',')
		url = HOST + "sf1?key=#{key}&get=#{api_variables},NAME&for=state:#{states}"
		output = open(url)
		return parse(output, key)
	end
	# Get ACS 2010 5 year data for for the states
	# <tt>census_acs_2010</tt> and pass it key,  list of states (FIPS codes or
	# state names) and api_variables
	# (http://www.census.gov/developers/data/2010acs5_variables.xml).
	# This will return array of hashes.
	#
	# <tt>USCensus::census_acs_2010(key, ["California"], ["B02001_001E"])</tt>
	#
	def self.census_acs_2010(key, states = "*", api_variables = ["B02001_001E"])
		states = fips_codes(states)
		api_variables = api_variables.join(',')
		url = HOST + "acs5?key=#{key}&get=#{api_variables},NAME&for=state:#{states}"
		output = open(url)
		return parse(output,key)
	end
	private
	def self.fips_codes(states)
		if states.is_a? Array
			states.map do |s|
				STATES[s] || s
			end.join(',')
		else
			states
		end
	end
	def self.parse(output, key)
		status = output.status[0]
		if "400" == status
			raise "Request was not valid. Queried for unknown variables or unknown geographies: #{ouput.read}"
		elsif "500" == status
			raise "Server side error while processing the request. Try again."
		elsif "204" == status
			return []
		elsif "200" == status
			if output.base_uri.to_s.match /invalid_key/
				raise "The key with this request it not valid: #{key}"
			else
		    return array_to_hash YAML.load output.read	
			end
		else
			raise "Unknown status code: #{status}"
		end
	end
	def self.array_to_hash(output)
    length = output.size
		return [] if length <= 1
		keys = output.first
		raise "No keys found." if keys.size == 0
		arr = []
		output[1..-1].map do |o|
			h = Hash.new
			keys.each_with_index do |v, i|
				h[v] = o[i]
			end
			arr << h
		end
		return arr
	end
end
