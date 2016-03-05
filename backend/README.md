# Time Traveler Backend

## Start Server
Install node in your computer and the use the following fromt the `backend` folder.

```Bash
node server.js
```

## Flight Info Service

### URL
`GET /flightInfo/:booking_code`

### cURL Example

`curl -XGET 'http://localhost:8080/flightInfo/267MRS'`

[example file](json-objects/examples/flight_info.json)

## Customer Information
This service responses the customer information by given `last name` and `first name`.

### URL

`GET /customer?ln=:last_name&fn=:first_name`

### cURL

`curl -XGET 'http://localhost:8080/customer?ln=Vielflieger&fn=Hannes'`

[example file](json-objects/examples/customer_info.json)

## Customer Address Info

### URL

`GET /customer/:customer_id/address`

`:customer_id` can be acquire from **customer information** service, parameter `ProfileID`.

### cURL

`curl -XGET 'http://localhost:8080/customer/cust_001/address'`

[example file](json-objects/examples/customer_address.json)

## Airport Information by airport code

### URL
`GET /airportInfo/:airport_code`

### cURL
`curl -XGET 'http://localhost:8080/airportInfo/FRA'`

[example file](json-objects/examples/airport_info.json)

## Search location
Search for locations by given Name

### URL
`GET /locations?location=:location_name`

### cURL
The result is a list of possible matches (locations) where the user might pick one entry to perform
a trip request with this location as origin or destination or to ask for a departure board or
arrival board of this location (stops/stations only).

`curl -XGET 'http://localhost:8080/locations?location=Frankfurt'`

[example file](json-objects/examples/locations_frankfurt.json)

## Nearby Locations by given Coordinates

### URL
`GET /nearbystops?originCoordLat=:LATITUDE&originCoordLong=:LONGITUD`

### cURL
For this example, it will response the nearby locations to HOLM.

`curl -XGET 'http://localhost:8080/nearbystops?originCoordLat=50.056446&originCoordLong=8.592368'`

[example file](json-objects/examples/nearby_example.json)

## Trip to airport
This service will response the trip from the location corrdinates to the airport with given airport code.

### URL
`GET /tripToAirport?originCoordLat=:LATITUDE&originCoordLong=:LONGITUD&airportCode=:AIRPORT_CODE`

### cURL
It will response all the possible trips from HOLM to FRA.

`curl -XGET 'http://localhost:8080/tripToAirport?originCoordLat=50.056446&originCoordLong=8.592368&airportCode=FRA'`

[example file](json-objects/examples/trip_example.json)

## Search DB Station

### URL
`GET /trainStation?station=:STATION_NAME`

### cURL
`http://localhost:8080/trainStation?station=Frankfurt`

[example file](json-objects/examples/db_stations.json)

## Train Departure Schedule from Station

### URL
`GET /departureSchedule?station_id=008096021&date=2016-03-06&time=07:02`

### cURL

`curl -XGET 'http://localhost:8080/departureSchedule?station_id=008096021&date=2016-03-06&time=07:02'`

[example file](json-objects/examples/departure_schedule.json)

## Waiting time at Checkin and Security

### URL
`GET /waitingperiod/checkin?airline=LH&flightnumber=400`

`GET /waitingperiod/security?airline=LH&flightnumber=400&date=2016-03-06`

### cURL

`curl -XGET 'http://localhost:8080/waitingperiod/checkin?airline=LH&flightnumber=400'`

`curl -XGET 'http://localhost:8080/waitingperiod/security?airline=LH&flightnumber=400&date=2016-03-06'`

[example file](json-objects/examples/waitingperiod.json)
