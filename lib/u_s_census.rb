require 'open-uri'
require 'yaml'

require "u_s_census/version"

module USCensus
  HOST = "http://thedataweb.rm.census.gov/data/2010/"

	def self.census_summary_2010(key, state = "*")
		url = HOST + "sf1?key=#{key}&get=P0010001,NAME&for=state:#{state}"
		output = open(url)
		return parse(output, key)
	end
	private
	def self.parse(output, key)
		status = output.status[1]
		if 400 == status
			raise "Request was not valid. Queried for unknown variables or unknown geographies: #{ouput.read}"
		elsif 500 == status
			raise "Server side error while processing the request. Try again."
		elsif 204 == status
			return []
		elsif 200 == status
			puts output.base_uri.to_s
			if output.base_uri.to_s.match /invalid_key/
				raise "The key with this request it not valid: #{key}"
			else
		    return array_to_hash YAML.load output.read	
			end
		else
			raise "Unknow status code: #{status}"
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
