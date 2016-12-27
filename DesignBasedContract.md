# GDSProject Contract Template


##Introduction

Several flight carriers have come together to create an online booking system. The project name is Sebastian. Access to this GDS (Global Distribution System) will be done through a web service (used by third party solutions) and a desktop application (meant for employees in travel agencies). Sebastian provides a service to view schedules* and handle bookings*.   

##Vision

###General describtion of system

Sebastian is a Global Distribution System, that is used to handle bookings, i.e. cancel, view and create, and show schedules of flights between specified airports on given dates, where it is possible to view arrival- and departure times and destination (including the names of the airports), information about the carrier and the number of free seats. 

###General describtion of porpuse of the system

The purpose of the system is to make it easier for several flight carriers and travel agencies to make reservations through an online solution. The solution will be in form of a web-service, that is meant for third-party solutions, and then a desktop solution for the employees. The system can handle many flight reservations, and can be extended with more features like seat numbers.

###Glossary

> <b>IATA</b> Carrier Code: A two-letter code that identifies a carrier (e.g. BA = British, RA = Ryan Air). 

> <b>IATA Airport Code:</b> A three-letter code that identifies an airport (e.g. CPH = Copenhagen Airport, HRG = Hurghada Airport).

> <b>Leg:</b> A flight leg is a flight from one point to another point (e.g. CPH -> HRG).

> <b>PNR (Passenger Name Record):</b> A unique combination of numbers and letters, that identifies a passenger. 

##Use Case Model

###Use case diagram

![USe Case Diagram](https://github.com/nmcristian/DesignBasedContracts/blob/master/res/Use%20Case%20Model.jpg)

###Use case description

####Use case 1

> <b>Name:</b> Show time schedule

> The system should show a time schedule with arrival and departure time, with information about the carrier and number of free seats, between two airports on a given date.

####Use case 2

> <b>Name:</b> The system should be able to make a booking for up to 9 persons, between to airports on a given day. The booking can even be a one-way or a round-trip. 

####Use case 3

> <b>Name:</b> See a booking, providing a PNR from the booking.

####Use case 4

> <b>Name:</b> Cancel a booking, providing a PNR from the booking.

###Actor descriptions

> <b>Employee:</b> The employee is the employees from the travel agencies.

##Domain Model

###Domain Model

![Class Diagram](https://github.com/nmcristian/DesignBasedContracts/blob/master/res/Domain%20Model.png)

###Class diagram

![Class Diagram](https://github.com/nmcristian/DesignBasedContracts/blob/master/res/Class%20Diagram.PNG)

###Description of domain model

> <b>Schedule:</b> Contains all flights from and to a specified date

> <b>Flight:</b> Contains information about a flight

> <b>Booking:</b> Is attached to a specific flight, and includes a single or multiple passengers

> <b>Passenger:</b> Contains basic passenger identifiers (name and id)

> <b>TicketType:</b> Enum, to define the possible ticket types (of a booking)

###Constraints

####Flight:
> <b>CarrierCode:</b> Two letter value (min & max)

> <b>AirportDeparture:</b> Three letter value (min & max)

> <b>AirportArrival:</b> Three letter value (min & max)

####Booking:
> <b>FrequentFlyterNumber:</b> Nullable, passengers may not have this attribute

> <b>Passengers:</b> Minimum 1 passenger, maximum 9

####Passenger:
> <b>PNR:</b> A combination of numbers and letters
* Always contains six alphanumeric characters
* First character can NOT be a number

> <b>FullName:</b> Full name (from passport) in capital letters

##Fully dressed use case

> <b>Name:</b> The system should be able to make a booking for up to 9 persons, between to airports on a given day. The booking can even be a one-way or a round-trip. 

> <b>Primary actor:</b> Employee from travel agency.

> <b>Precondition:</b> Should be no more than 9 persons on each booking

> <b>Success scenario:</b> An message should say, that all persons has been booked on the flight 

> <b>Error scenario:</b> If no seats available, an error message should appear. 

> <b>Special requirements:</b> The booking is atomic, and can only be successful, if all persons can be booked, and all legs are included.

##Architectural Requirements

###Non-functional Requirements

1. Create a webservice (to be used by 3rd party users and desktop application)
2. Encryption of personal data on passengers (e.g. credit card information)
    - Database encryption in case of breach
    - HTTPS for secure communication
3. Backups of database data (bookings, flights etc.)
4. It should not take any more than five minutes to create a booking 
5. The booking system should be able to handle fluctuating number of users (heavy load in high season)
6. Documentation for use of web service for 3rd party users

##System Architecture

###Package diagram

![Package Diagram](https://github.com/nmcristian/DesignBasedContracts/blob/master/res/Package.png)

The package diagram is showing the structure of the diagram, and which packages it is containing. 

> <b>GUI:</b> The user interface made as an application, or a browser based solution used by customers.

> <b>Domain:</b> Domain is handling all requests, and can be accessed by using the interface. 

> <b>Technical Service:</b> Is handling database related calls through a DBFacade.

###Component diagram

![Component Diagram](https://github.com/nmcristian/DesignBasedContracts/blob/master/res/Component%20diagram.png)

The component diagram shows which systems is using the repository, and which methods you can call. It is possible to call the four main methods through a web service. The desktop and 3-party solution is calling the repository, who has handling all the bookings. 

###Architecture structure

![Sequence Diagram](https://github.com/nmcristian/DesignBasedContracts/blob/master/res/seq2.png)

###Implementation

<b>Use case:</b> Create Booking

<b>Main Scenario:</b>

1.1 Get flight schedule between two airports

1.2 Check if flight have any seats left

1.3 Get response if booking is successful


This interface provides the methods for creating a successful booking. 

```c#
interface ISebastian
    {
        /// <summary>
        /// Returns a JSON array of flights between the specified dates
        /// </summary>
        /// <param name="dateFrom"></param>
        /// <param name="dateTo"></param>
        /// <returns>JSON response</returns>
        string GetScheduledFlights(DateTime dateFrom, DateTime dateTo);


        /// <summary>
        /// Returns a JSON object of a flight and its bookings 
        /// </summary>
        /// <param name="flightId"></param>
        /// <returns></returns>
        string GetFlightBookings(string flightId);


        /// <summary>
        /// Returns a JSON response with information about the success of the request
        /// </summary>
        /// <param name="flight"></param>
        /// <param name="booking"></param>
        /// <returns>JSON response</returns>
        string CreateBooking(Flight flight, Booking booking);
    }
```



This is how the JSON object could look like, when creating a new booking. 


> <b>(GetFlightBookings)</b>

```JSON
"Flight": [
    {
      "AirportDeparture": "CPH",
      "AirportArrival": "HRG",
      "DateDeparture": "2016/12/11 12:20",
      "DateArrival": "2016/12/11 18:30",
      "SeatCount": 148,
      "TicketPrice": 1200.00,
      "CarrierCode": "SAS",
      "Bookings": [
        {
          "Passengers": [
            {
              "PNR": "A72645263ER",
              "FullName": "JENS ANDERSEN"
            },
            {
              "PNR": "A726453432ER",
              "FullName": "KAREN ANDERSEN"
            },
            {
              "PNR": "A788853432ER",
              "FullName": "AUGUST ANDERSEN"
            }
          ],
          "TicketType": "RoundTrip",
          "CreditCardNumber": "1234567890",
          "FrequentFlyerNumber": "A27E"
        },
        {       
"Passengers": [
            {
              "PNR": "A72645263EUO",
              "FullName": "JENS PETERSEN"
            },
            {
              "PNR": "A726453432EO",
              "FullName": "KAREN PETERSEN"
            },
            {
              "PNR": "A788853432EB",
              "FullName": "AUGUST PETERSEN"
            }
          ],
          "TicketType": "RoundTrip",
          "CreditCardNumber": "1234567890",
          "FrequentFlyerNumber": "A27E"
        }
      ]
    }
  ]
  
```

> <b>(GetFlightBookings)</b>

```JSON
 "Schedule": {
    "DateFrom": "2016/12/09",
    "DateTo": "2016/12/12",
    "Flights": [
      {
        "FlightId": "BA124-1542AE",
        "AirportDeparture": "CPH",
        "AirportArrival": "HRG",
        "DateDeparture": "2016/12/11 12:20",
        "DateArrival": "2016/12/11 18:30",
        "SeatCount": 148,
        "TicketPrice": 1200.00,
        "CarrierCode": "SAS",
        "Bookings": null
      },
      {
        "FlightId": "BA124-3333AI",
        "AirportDeparture": "AAL",
        "AirportArrival": "CPH",
        "DateDeparture": "2016/12/09 12:20",
        "DateArrival": "2016/12/09 14:00",
        "SeatCount": 148,
        "TicketPrice": 800.00,
        "CarrierCode": "SAS",
        "Bookings": null
      },
      {
        "FlightId": "BA129-3445AI",
        "AirportDeparture": "CPH",
        "AirportArrival": "LND",
        "DateDeparture": "2016/12/10 12:20",
        "DateArrival": "2016/12/10 15:30",
        "SeatCount": 148,
        "TicketPrice": 1200.00,
        "CarrierCode": "SAS",
        "Bookings": null
      }
    ]
  }

```


> <b>(GetFlightBookings)</b>

```JSON
 "Response": "Booking successfully added to flight 'BA124-3333AI'"

```

###Persistence

The data storage will be handled in a relational database. Due to the different constraint-requirements, it makes sense to implant these constraints on a data layer-level - which relational databases allows. An alternative would be, to use NoSQL/document-style database. This database type allows for faster performance and more dynamic storage structure, however, these advantages are not sufficient to choose a document database above the relational kind. 

###E/R Diagram

![Sequence Diagram](https://github.com/nmcristian/DesignBasedContracts/blob/master/res/ER_model_2_not_transparent.png)


###Design part - Cristian Nita

Since the team I've been working with chose the second use case('Create Booking'), I will go for the first one('Show time schedule' = 'Show a time schedule between two airports on a given day. The schedule should besides departure and arrival times include information about the carrier and number of free seats on the flights').

###Design Class Diagram

![Class Diagram](https://github.com/nmcristian/DesignBasedContracts/blob/master/res/ClassDiagramShowTimeSchedule.png)


###Design Sequence Diagram

The sequence diagram for getting the Flight schedule based on departure, arrival and date.

![Sequence Diagram](https://github.com/nmcristian/DesignBasedContracts/blob/master/res/DesignSequenceDiagram.png)


###State Diagram 

![State Diagram](https://github.com/nmcristian/DesignBasedContracts/blob/master/res/StateDiagram.png)


Relational Model (with table names, data types and primary/foreign keys)

![Relational Model](https://github.com/nmcristian/DesignBasedContracts/blob/master/res/RelationalModel.png)
