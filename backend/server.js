// server.js

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
  this.kilometers = options.kilometers || null;
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

var routeNearbyStops  = function(data, response) {
  var originLat = data.originCoordLat;
  var originLong = data.originCoordLong;
  apicalls.performRmvRequest('/location.nearbystops', {originCoordLong: originLong, originCoordLat: originLat}, function(response) {
    callback(null, response);
  });
};

var routeTripToAirport  = function(data, callback) {
  var airportCode = data.airportCode;
  var originLat = data.originCoordLat;
  var originLong = data.originCoordLong;
  routeAirportInfoWithCode({airport_code: airportCode}, function (err, response) {
    var coord = response.Position.Coordinate;
    apicalls.performRmvRequest('/trip', {
      originCoordLat: originLat,
      originCoordLong: originLong,
      destCoordLat: coord.Latitude,
      destCoordLong: coord.Longitude
    }, function(response2) {
      callback(null, response2);
    });
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
    apicalls.performFraportRequest('gates','/gates/'+gate, null, function(response2) {
      var securityCheckName = response2[0].gate.departure_securitycheck;
      routeWaitingPeriodPlace({name:securityCheckName}, function(err, response3){
        callback(null, response3)
      })
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
    callback(null, response[0].path);
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
  routeTripToAirport({airportCode: req.query.airportCode,originCoordLat: req.query.originCoordLat, originCoordLong:req.query.originCoordLong}, function(err, response) {
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

var async = require('async');

var routeGetJourney = function(data, callback){
  // TODO:
  var journey = [];
  // Flight
  var now = new Date();
  var loc = new Position({lat:'1', long:'2', name: 'A2'});
  var dist = new Distance({minutes: '11', kilometers: '1'});

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
        next(null, date, 'two');
      })
    },
    function idControll(startTime, arg2, next) {
      // TODO:
      journey.unshift(
        new JourneyPart({
          start: now,
          end: now,
          name: 'ID Check',
          location: loc,
          distance: dist
        })
      );
      next(null, 'one', 'three');
    },
    function securityControll(startTime, arg2, next) {
      // TODO:
      journey.unshift(
        new JourneyPart({
          start: now,
          end: now,
          name: 'Security Check',
          location: loc,
          distance: dist
        })
      );
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
