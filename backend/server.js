// server.js

var fraport = {
    airportCode: "FRA",
	position: {
		coordinate: {
			latitude: 50.03194444,
			longitude: 8.577777778
		}
	},
	cityCode: "FRA",
	countryCode: "DE",
	locationType: "Airport",
	name: "Frankfurt/Main International",
    trainStation: {
        name: "Frankfurt(M) Flughafen Regionalbf",
        longitude: 8.571250,
        latitude: 50.051218,
        id: "008070004"
    }
};

// BASE SETUP
// =============================================================================

// call the packages we need
var express    = require('express');        // call express
var app        = express();                 // define our app using express
var bodyParser = require('body-parser');
var apicalls   = require('./apicalls.js');

// configure app to use bodyParser()
// this will let us get the data from a POST
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var port = process.env.PORT || 8080;        // set our port

// Class for each little part of our Journey
function JourneyPart (options)  {
  this.start = options.start || null;
  this.end = options.end || null;
  this.location = new Position(options.location);
  this.name = options.name || null;
  this.distance = new Distance(options.distance);
}

function Position (options) {
  this.lat = options.lat|| null;
  this.long = options.long|| null;
  this.name = options.name|| null;
}

function Distance (options) {
  this.minutes = options.minutes || null;
  this.meters = options.meters || null;
}

// Functions for our Routes
// =============================================================================

var routeFlightInfoBookinCode = function(data, callback){
  var bookingCode = data.booking_code;
  apicalls.performLufthansaRequest('mockup/profiles/ordersandcustomers/pnrid/'+bookingCode, { callerid: 'team1' }, function(response) {
    var flights = response.CustomersAndOrdersResponse.Orders.Order.OrderItems.OrderItem.FlightItem.OriginDestination.Flight;
    callback(null, flights);
  });
};

var routeCustomer = function(data, callback){
  var lastName = data.ln;
  var firstName = data.fn;
  apicalls.performLufthansaRequest('mockup/profiles/customers/'+lastName+'/'+firstName, { filter: 'id', callerid: 'team1' }, function(response) {
    callback(null, response.CustomersResponse.Customers.Customer);
  });
};

var routeCustomerIdAdress = function(data, callback) {
  var customerId = data.customer_id;
  apicalls.performLufthansaRequest('mockup/profiles/customers/'+customerId, { callerid: 'team1' }, function(response) {
    callback(null, response.CustomersResponse.Customers.Customer.Contacts.Contact.AddressContact);
  });
};

var routeAirportInfoWithCode = function(data, callback) {
  var airportCode = data.airport_code;
  apicalls.performLufthansaRequest('references/airports/'+airportCode, { filter: 'id', callerid: 'team1' }, function(response) {
    callback(null, response.AirportResource.Airports.Airport);
  });
};


var routeLocations = function(data, callback) {
  var location = data.location;
  apicalls.performRmvRequest('/location.name', {input: location}, function(response) {
    callback(null,response);
  });
};

var routeNearbyStops  = function(data, callback) {
  var originLat = data.originCoordLat;
  var originLong = data.originCoordLong;
  apicalls.performRmvRequest('/location.nearbystops',{originCoordLong: originLong, originCoordLat: originLat}, function(response) {
    callback(null, response);
  });
};

var routeTripToAirport  = function(data, callback) {
  var originLat = data.originCoordLat;
  var originLong = data.originCoordLong;
  apicalls.performRmvRequest('/trip', {
    originCoordLat: originLat,
    originCoordLong: originLong,
    destCoordLat: fraport.trainStation.latitude,
    destCoordLong: fraport.trainStation.longitude,
    originBike: 0
  }, function(response) {
    callback(null, response);
  });
};

var routeTrainStation = function(data, callback){
  var station = data.station;
  apicalls.performDbRequest('/location.name', {input: station}, function(response) {
    callback(null, response);
  });
};

var routeDepartureSchedule = function(data, callback){
  var stationId = data.station_id;
  var date = data.date;
  var time = data.time;
  apicalls.performDbRequest('/departureBoard', {id: stationId, date: date, time: time}, function(response) {
    callback(null, response);
  });
};

var routeGateInfo = function(data, callback){
    apicalls.performFraportRequest('gates','/gates/'+data.gate, null, function(response) {
        callback(null, response);
    });
};

var routeWaitingPeriodSecurity = function(data, callback){
  //TODO: Reduce Api-Querys
  var airline = data.airline;
  var flightnumber = data.flightnumber;
  var departuredate = data.date;
  // var airline = 'LH';
  // var flightnumber = '400';
  // var departuredate = '2016-03-05';
  apicalls.performLufthansaRequest('operations/flightstatus/'+airline+flightnumber+'/'+departuredate, null, function(response) {
    var gate = response.FlightStatusResource.Flights.Flight.Departure.Terminal.Gate;
    routeGateInfo({gate: gate}, function(err, response2) {
      var securityCheckName = response2[0].gate.departure_securitycheck;
      routeWaitingPeriodPlace({name:securityCheckName}, function(err, response3){
        callback(null, response3)
      });
    });
  });
};

var routeWaitingPeriodPlace = function(data, callback){
  apicalls.performFraportRequest('waitingperiods', '/waitingperiod/' + data.name, null, function(response){
    //var waitingTime = response2[0].processSite.waitingTime;
    callback(null, response[0].processSite);
  });
};

var routeWaitingPeriodCheckin = function(data, callback){
  //var airline = 'LH';
  //var flightnumber = '400';
  var airline = data.airline;
  var flightnumber = data.flightnumber;
  apicalls.performFraportRequest('checkininfo','/checkininfo/'+airline, null, function(response) {
    var checkIns = response[0].airline.checkIns;
    var firstCheckIn = checkIns[0].checkIn.name;
    routeWaitingPeriodPlace({name:firstCheckIn}, function(err, response2){
      callback(null, response2)
    });
  });
};

var routeDistance = function(data, callback){
  var start = data.start;
  var end = data.end;
  // var start = 'Check-In A';
  // var end = 'Central Security-Check A';
  apicalls.performFraportRequest('transittimes','/transittime/'+start+'/'+end, null, function(response) {
      console.log("---->"+start);
      console.log("---->"+end);
      callback(null, response[0].path);
  });
};

var routeParkingAvailability = function(data, callback){
  apicalls.performFraportRequest('parking','/parking/current', null, function(response) {
    callback(null, response);
  });
};

var routeParkingAvailabilityForecast = function(data, callback){
  apicalls.performFraportRequest('parking','/parking/forecast/', null, function(response) {
    callback(null, response);
  });
};

var routeFlightStatus = function(data, callback){
  var airline = data.airline;
  var flightnumber = data.flightnumber;
  var departuredate = data.date;
  apicalls.performLufthansaRequest('operations/flightstatus/'+airline+flightnumber+'/'+departuredate, null, function(response) {
    callback(null, response.FlightStatusResource.Flights.Flight);
  });
};

// ROUTES FOR OUR API
// =============================================================================

var router = express.Router();              // get an instance of the express Router

// test route to make sure everything is working (accessed at GET http://localhost:8080/api)
router.get('/', function(req, res) {
  res.json({ message: 'hooray! welcome to Time Traveler Seerver API!' });
});

router.route('/flightInfo/:booking_code')
.get(function(req, res){
  routeFlightInfoBookinCode({booking_code: req.params.booking_code}, function(err, response) {
    res.json(response);
  })
});

router.route('/customer')
.get(function(req, res) {
  routeCustomer({ln: req.query.ln, fn: req.query.fn}, function(err, response) {
    res.json(response);
  })
});

router.route('/customer/:customer_id/address')
.get(function(req, res) {
  routeCustomerIdAdress({customer_id: req.params.customer_id}, function(err, response) {
    res.json(response);
  })
});

router.route('/airportInfo/:airport_code')
.get(function(req, res) {
  routeAirportInfoWithCode({airport_code: req.params.airport_code}, function(err, response) {
    res.json(response);
  })
});

router.route('/locations')
.get(function(req, res) {
  routeLocations({location: req.query.location}, function(err, response) {
    res.json(response);
  });
});

router.route('/nearbystops')
.get(function(req, res) {
  routeNearbyStops({originCoordLat: req.query.originCoordLat, originCoordLong:req.query.originCoordLong}, function(err, response) {
    res.json(response);
  });
});

router.route('/tripToAirport')
.get(function(req, res) {
  routeTripToAirport({originCoordLat: req.query.originCoordLat, originCoordLong:req.query.originCoordLong}, function(err, response) {
    res.json(response);
  });
});

router.route('/trainStation')
.get(function(req, res) {
  routeTrainStation({station: req.query.station}, function(err, response){
    res.json(response);
  });
});

router.route('/departureSchedule')
.get(function(req, res) {
  routeDepartureSchedule({station_id: req.query.station_id,data:req.query.date ,time: req.query.time}, function(err, response){
    res.json(response);
  });
});

router.route('/waitingperiod/security')
.get(function(req, res) {
  routeWaitingPeriodSecurity({airline:req.query.airline,flightnumber:req.query.flightnumber,date:req.query.date }, function(err, response){
    res.json(response);
  });
});

router.route('/waitingperiod/checkin')
.get(function(req, res) {
  routeWaitingPeriodCheckin({airline:req.query.airline,flightnumber:req.query.flightnumber}, function(err, response){
    res.json(response);
  });
});

router.route('/distance')
.get(function(req, res) {
  routeDistance({start:req.query.start,end:req.query.end }, function(err, response){
    res.json(response);
  })
});

router.route('/getJourney')
.get(function(req, res){
  routeGetJourney({booking_code: req.params.booking_code}, function(err, response) {
    res.json(response);
  });
});

router.route('/parkingAvailability')
.get(function(req, res){
  routeParkingAvailability({}, function(err, response) {
    res.json(response);
  });
});

router.route('/parkingAvailabilityForecast')
.get(function(req, res){
  routeParkingAvailabilityForecast({}, function(err, response) {
    res.json(response);
  });
});

router.route('/flightStatus')
.get(function(req, res){
  var airlineCode = req.query.airline_code;
  var flightNumber = req.query.flight_number;
  var departureDate = req.query.departure_date;
  routeFlightStatus({airline: airlineCode, flightnumber: flightNumber, date: departureDate}, function(err, response) {
    res.json(response);
  });
});

var async = require('async');

var routeGetJourney = function(data, callback){
  // TODO:
  var journey = [];
  // Flight
  var now = new Date();
  var loc = new Position({lat:'1', long:'2', name: 'A2'});
  var dist = new Distance({minutes: '11', meters: '1'});

  async.waterfall([
    function flightPart(next) {
      routeFlightInfoBookinCode({booking_code: data.booking_code}, function(err, response) {
        console.log(response);
        // TODO: get Location of Gate, get Distance, Customize name
        var date = new Date(response.Departure.Date + ' ' + response.Departure.Time);
        journey.unshift(
          new JourneyPart({
            start: date,
            end: date,
            name: 'Departure Flight',
            location: loc,
            distance: dist
          })
        );
        next(null, date, loc);
      })
    },
    function idControll(endTime, gate, next) {
        // 1. Query Id-Kontrolle for flight gate
        routeGateInfo({gate: gate.name}, function(err, response){
             // 2. Query Distance between gate and controll
            //gate.name = 'A-Gates'; // FIXME: Weggucken, hier gibt es nichts zu sehen
            console.log(response.length);
            var gateSectionName = (gate.name).charAt(0)+"-Gates";
            console.log(response.length);
            routeDistance({start: response[0].gate.departure_bordercheck, end: gateSectionName}, function(err, response2){
                // 3. TODO: Calculate Time for start
                var startTime = now; //FIXME
                var pos = new Distance({meters: response2.distance, minutes: response2.transitTime});
                    journey.unshift(
                        new JourneyPart({
                        start: now,
                        end: endTime,
                        name: 'Border Check',
                        location: loc,
                        distance: pos
                        })
                    );
                next(null, startTime, gate);
            });
        });
    },
    function securityControll(endTime, gate, next) {
         // 1. Query Id-Kontrolle for flight gate
        routeGateInfo({gate: gate.name}, function(err, response){
         // 2. Query Distance between gate and controll
         gate.name = 'A-Gates'; // FIXME: Weggucken, hier gibt es nichts zu sehen
            routeDistance({start: response[0].gate.departure_securitycheck, end: gate.name}, function(err, response2){
            // 3. TODO: Calculate Time for start
            var startTime = now; //FIXME
            var pos = new Distance({meters: response2.distance, minutes: response2.transitTime});
           // var loc = new Position() //FIXME
                journey.unshift(
                    new JourneyPart({
                    start: now,
                    end: endTime,
                    name: 'Security Check',
                    location: loc,
                    distance: pos
                    })
                );
                next(null, startTime, gate);
            });
        });
      next(null, 'one', 'three');
    },
    function checking(startTime, arg2, next) {
      // TODO:
      journey.unshift(
        new JourneyPart({
          start: now,
          end: now,
          name: 'Check-In',
          location: loc,
          distance: dist
        })
      );
      next(null, 'one', 'three');
    },
    function arrivalAirport(startTime, arg2, next) {
      // TODO:
      journey.unshift(
        new JourneyPart({
          start: now,
          end: now,
          name: 'Arrival Airport',
          location: loc,
          distance: dist
        })
      );
      next(null, 'one', 'three');
    },
    function publicTransport(startTime, arg2, next) {
      // TODO:
      /* TODO: Zwischenschritte des ÖPNV */
      journey.unshift(
        new JourneyPart({
          start: now,
          end: now,
          name: 'Changing to Train',
          location: loc,
          distance: dist
        })
      );
      journey.unshift(
        new JourneyPart({
          start: now,
          end: now,
          name: 'Departure Bus',
          location: loc,
          distance: dist
        })
      );
      next(null, 'one', 'three');
    },
    function startAtHome(arg1, arg2, next) {
      // arg1 now equals 'three'

      journey.unshift(
        new JourneyPart({
          start: now,
          end: now,
          name: 'Leaving Home',
          location: loc,
          distance: dist
        })
      );
      next(null, 'done');
    }
  ], function (err, result) {
    callback(err, journey);
  });
};

// more routes for our API will happen here

// REGISTER OUR ROUTES -------------------------------
// all of our routes will be prefixed with /api
app.use('/', router);

// START THE SERVER (after initalising the APIs)
// =============================================================================
apicalls.initApis(function () {
  app.listen(port);
  console.log('Magic happens on port ' + port);

  routeGetJourney({booking_code: '267MDE'}, function(err, response) {
    console.log(response);
  });

});
