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

// ROUTES FOR OUR API
// =============================================================================
var router = express.Router();              // get an instance of the express Router

// test route to make sure everything is working (accessed at GET http://localhost:8080/api)
router.get('/', function(req, res) {
    res.json({ message: 'hooray! welcome to Time Traveler Seerver API!' });
});

router.route('/flightInfo/:booking_code')
    .get(function(req, res){
        var bookingCode = req.params.booking_code;
        apicalls.performLufthansaRequest('mockup/profiles/ordersandcustomers/pnrid/'+bookingCode, { callerid: 'team1' }, function(response) {
            var flights = response.CustomersAndOrdersResponse.Orders.Order.OrderItems.OrderItem.FlightItem.OriginDestination.Flight;
            res.json(flights);
        });
    });

router.route('/customer')
    .get(function(req, res) {
        var lastName = req.query.ln;
        var firstName = req.query.fn;
        apicalls.performLufthansaRequest('mockup/profiles/customers/'+lastName+'/'+firstName, { filter: 'id', callerid: 'team1' }, function(response) {
          res.json(response.CustomersResponse.Customers.Customer);
        });
    });

router.route('/customer/:customer_id/address')
    .get(function(req, res) {
        var customerId = req.params.customer_id;
        apicalls.performLufthansaRequest('mockup/profiles/customers/'+customerId, { callerid: 'team1' }, function(response) {
          res.json(response.CustomersResponse.Customers.Customer.Contacts.Contact.AddressContact);
        });
    });

router.route('/airportInfo/:airport_code')
    .get(function(req, res) {
        var airportCode = req.params.airport_code;
        apicalls.performLufthansaRequest('references/airports/'+airportCode, { filter: 'id', callerid: 'team1' }, function(response) {
          res.json(response.AirportResource.Airports.Airport);
        });
    });

router.route('/locations')
    .get(function(req, res) {
        var location = req.query.location;
        apicalls.performRmvRequest('/location.name', {input: location}, function(response) {
          res.json(response);
        });
    });

router.route('/nearbystops')
    .get(function(req, res) {
        var originLat = req.query.originCoordLat;
        var originLong = req.query.originCoordLong;
        apicalls.performRmvRequest('/location.nearbystops', {originCoordLong: originLong, originCoordLat: originLat}, function(response) {
          res.json(response);
        });
    });

router.route('/tripToAirport')
    .get(function(req, res) {
        var airportCode = req.query.airportCode;
        var originLat = req.query.originCoordLat;
        var originLong = req.query.originCoordLong;
        apicalls.performLufthansaRequest('references/airports/'+airportCode, { filter: 'id', callerid: 'team1' }, function(response) {
          var coord = response.AirportResource.Airports.Airport.Position.Coordinate;
          var airportLat = coord.Latitude;
          var airportLong = coord.Longitude;
          apicalls.performRmvRequest('/trip', {originCoordLong: originLong, originCoordLat: originLat, destCoordLat: airportLat, destCoordLong: airportLong}, function(response) {
            res.json(response);
          });
        });
    });

router.route('/trainStation')
    .get(function(req, res) {
        var station = req.query.station;
        apicalls.initApis(function () {
            apicalls.performDbRequest('/location.name', {input: station}, function(response) {
              res.json(response);
            });
        });
    });

router.route('/departureSchedule')
    .get(function(req, res) {
        var stationId = req.query.station_id;
        var date = req.query.date;
        var time = req.query.time;
        apicalls.initApis(function () {
            apicalls.performDbRequest('/departureBoard', {id: stationId, date: date, time: time}, function(response) {
              res.json(response);
            });
        });
    });

// more routes for our API will happen here

// REGISTER OUR ROUTES -------------------------------
// all of our routes will be prefixed with /api
app.use('/', router);

// START THE SERVER (after initalising the APIs)
// =============================================================================
apicalls.initApis(function () {
  app.listen(port);
  console.log('Magic happens on port ' + port);
});
