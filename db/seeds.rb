# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Country.create([{ name: 'United State of America', abbr: 'USA' }])

State.create([
               { id: 1, name: 'Alabama', abbr: 'AL', timezone: 'America/Chicago', country_id: 1, lat: '32.799000', lng: '-86.807300' },
               { id: 2, name: 'Alaska', abbr: 'AK', timezone: 'America/Anchorage', country_id: 1, lat: '61.385000', lng: '-152.268300' },
               { id: 3, name: 'Arizona', abbr: 'AZ', timezone: 'America/Phoenix', country_id: 1, lat: '33.771200', lng: '-111.387700' },
               { id: 4, name: 'Arkansas', abbr: 'AR', timezone: 'America/Chicago', country_id: 1, lat: '34.951300', lng: '-92.380900' },
               { id: 5, name: 'California', abbr: 'CA', timezone: 'America/Los_Angeles', country_id: 1, lat: '36.170000', lng: '-119.746200' },
               { id: 6, name: 'Colorado', abbr: 'CO', timezone: 'America/Denver', country_id: 1, lat: '39.064600', lng: '-105.327200' },
               { id: 7, name: 'Connecticut', abbr: 'CT', timezone: 'America/New_York', country_id: 1, lat: '41.583400', lng: '-72.762200' },
               { id: 8, name: 'Delaware', abbr: 'DE', timezone: 'America/New_York', country_id: 1, lat: '39.349800', lng: '-75.514800' },
               { id: 9, name: 'Florida', abbr: 'FL', timezone: 'America/New_York', country_id: 1, lat: '27.833300', lng: '-81.717000' },
               { id: 10, name: 'Georgia', abbr: 'GA', timezone: 'America/New_York', country_id: 1, lat: '32.986600', lng: '-83.648700' },
               { id: 11, name: 'Hawaii', abbr: 'HI', timezone: 'Pacific/Honolulu', country_id: 1, lat: '21.109800', lng: '-157.531100' },
               { id: 12, name: 'Idaho', abbr: 'ID', timezone: 'America/Boise', country_id: 1, lat: '44.239400', lng: '-114.510300' },
               { id: 13, name: 'Illinois', abbr: 'IL', timezone: 'America/Chicago', country_id: 1, lat: '40.336300', lng: '-89.002200' },
               { id: 14, name: 'Indiana', abbr: 'IN', timezone: 'America/Indiana/Indianapolis', country_id: 1, lat: '39.864700', lng: '-86.260400' },
               { id: 15, name: 'Iowa', abbr: 'IA', timezone: 'America/Chicago', country_id: 1, lat: '42.004600', lng: '-93.214000' },
               { id: 16, name: 'Kansas', abbr: 'KS', timezone: 'America/Chicago', country_id: 1, lat: '38.511100', lng: '-96.800500' },
               { id: 17, name: 'Kentucky', abbr: 'KY', timezone: 'America/Kentucky/Louisville', country_id: 1, lat: '37.669000', lng: '-84.651400' },
               { id: 18, name: 'Louisiana', abbr: 'LA', timezone: 'America/Chicago', country_id: 1, lat: '31.180100', lng: '-91.874900' },
               { id: 19, name: 'Maine', abbr: 'ME', timezone: 'America/New_York', country_id: 1, lat: '44.607400', lng: '-69.397700' },
               { id: 20, name: 'Maryland', abbr: 'MD', timezone: 'America/New_York', country_id: 1, lat: '39.072400', lng: '-76.790200' },
               { id: 21, name: 'Massachusetts', abbr: 'MA', timezone: 'America/New_York', country_id: 1, lat: '42.237300', lng: '-71.531400' },
               { id: 22, name: 'Michigan', abbr: 'MI', timezone: 'America/Detroit', country_id: 1, lat: '43.350400', lng: '-84.560300' },
               { id: 23, name: 'Minnesota', abbr: 'MN', timezone: 'America/Chicago', country_id: 1, lat: '45.732600', lng: '-93.919600' },
               { id: 24, name: 'Mississippi', abbr: 'MS', timezone: 'America/Chicago', country_id: 1, lat: '32.767300', lng: '-89.681200' },
               { id: 25, name: 'Missouri', abbr: 'MO', timezone: 'America/Chicago', country_id: 1, lat: '38.462300', lng: '-92.302000' },
               { id: 26, name: 'Montana', abbr: 'MT', timezone: 'America/Denver', country_id: 1, lat: '46.904800', lng: '-110.326100' },
               { id: 27, name: 'Nebraska', abbr: 'NE', timezone: 'America/Chicago', country_id: 1, lat: '41.128900', lng: '-98.288300' },
               { id: 28, name: 'Nevada', abbr: 'NV', timezone: 'America/Los_Angeles', country_id: 1, lat: '38.419900', lng: '-117.121900' },
               { id: 29, name: 'New Hampshire', abbr: 'NH', timezone: 'America/New_York', country_id: 1, lat: '43.410800', lng: '-71.565300' },
               { id: 30, name: 'New Jersey', abbr: 'NJ', timezone: 'America/New_York', country_id: 1, lat: '40.314000', lng: '-74.508900' },
               { id: 31, name: 'New Mexico', abbr: 'NM', timezone: 'America/Denver', country_id: 1, lat: '34.837500', lng: '-106.237100' },
               { id: 32, name: 'New York', abbr: 'NY', timezone: 'America/New_York', country_id: 1, lat: '42.149700', lng: '-74.938400' },
               { id: 33, name: 'North Carolina', abbr: 'NC', timezone: 'America/New_York', country_id: 1, lat: '35.641100', lng: '-79.843100' },
               { id: 34, name: 'North Dakota', abbr: 'ND', timezone: 'America/North_Dakota/Center', country_id: 1, lat: '47.536200', lng: '-99.793000' },
               { id: 35, name: 'Ohio', abbr: 'OH', timezone: 'America/New_York', country_id: 1, lat: '40.373600', lng: '-82.775500' },
               { id: 36, name: 'Oklahoma', abbr: 'OK', timezone: 'America/Chicago', country_id: 1, lat: '35.537600', lng: '-96.924700' },
               { id: 37, name: 'Oregon', abbr: 'OR', timezone: 'America/Los_Angeles', country_id: 1, lat: '44.567200', lng: '-122.126900' },
               { id: 38, name: 'Pennsylvania', abbr: 'PA', timezone: 'America/New_York', country_id: 1, lat: '40.577300', lng: '-77.264000' },
               { id: 39, name: 'Rhode Island', abbr: 'RI', timezone: 'America/New_York', country_id: 1, lat: '41.677200', lng: '-71.510100' },
               { id: 40, name: 'South Carolina', abbr: 'SC', timezone: 'America/New_York', country_id: 1, lat: '33.819100', lng: '-80.906600' },
               { id: 41, name: 'South Dakota', abbr: 'SD', timezone: 'America/Chicago', country_id: 1, lat: '44.285300', lng: '-99.463200' },
               { id: 42, name: 'Tennessee', abbr: 'TN', timezone: 'America/Chicago', country_id: 1, lat: '35.744900', lng: '-86.748900' },
               { id: 43, name: 'Texas', abbr: 'TX', timezone: 'America/Chicago', country_id: 1, lat: '31.106000', lng: '-97.647500' },
               { id: 44, name: 'Utah', abbr: 'UT', timezone: 'America/Denver', country_id: 1, lat: '40.113500', lng: '-111.853500' },
               { id: 45, name: 'Vermont', abbr: 'VT', timezone: 'America/New_York', country_id: 1, lat: '44.040700', lng: '-72.709300' },
               { id: 46, name: 'Virginia', abbr: 'VA', timezone: 'America/New_York', country_id: 1, lat: '37.768000', lng: '-78.205700' },
               { id: 47, name: 'Washington', abbr: 'WA', timezone: 'America/Los_Angeles', country_id: 1, lat: '47.391700', lng: '-121.570800' },
               { id: 48, name: 'Washington DC', abbr: 'DC', timezone: 'America/New_York', country_id: 1, lat: '38.896400', lng: '-77.026200' },
               { id: 49, name: 'West Virginia', abbr: 'WV', timezone: 'America/New_York', country_id: 1, lat: '38.468000', lng: '-80.969600' },
               { id: 50, name: 'Wisconsin', abbr: 'WI', timezone: 'America/Chicago', country_id: 1, lat: '44.256300', lng: '-89.638500' },
               { id: 51, name: 'Wyoming', abbr: 'WY', timezone: 'America/Denver', country_id: 1, lat: '42.747500', lng: '-107.208500' }
             ])