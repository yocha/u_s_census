require 'spec_helper'

describe USCensus do
	it "raises an exception" do
		lambda {USCensus::census_summary_2010('xxxx')}.should raise_error
	end
end
