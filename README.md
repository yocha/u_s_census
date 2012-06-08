# USCensus

Access US Census data using the provided API beginning with 2010 Census Summary
File 1 and the 2010 American Community Survey.

See http://www.census.gov/developers/

## Installation

Add this line to your application's Gemfile:

    gem 'u_s_census'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install u_s_census

## Usage

### Requirement

Get key (http://www.census.gov/developers/)

### Function call

 ```ruby
 key = "xxxxxxxx"
 USCensus::census_summary_2010(key)
 ```
## Development

Questions or problems? Please post them on the [issue tracker]
(https://github.com/yocha/u_s_census/issues). You can contribute changes by
forking the project and submitting a pull request. 

This gem is created by Yong Cha and is under the MIT License.
