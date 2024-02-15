# -*- coding: utf-8 -*-
"""
Created on Fri Oct 13 15:16:44 2023

@author: camga
"""
import pymongo

from pymongo.mongo_client import MongoClient

uri = "mongodb+srv://gallienc:Recovery33@cluster0.nyf6ooz.mongodb.net/?retryWrites=true&w=majority"

client = MongoClient(uri)

try:
    client.admin.command('ping')
    print("Pinged your deployment. You successfully connected to MongoDB!")
except Exception as e:
    print(e)

db = client["AirlineDB"]
    
data_model = {
    "Passengers": [
        {
            "Passenger_id": 1,
            "First_name": "Tim",
            "Second_name": "Cam",
            "Last_name": "Thomas",
            "Phone_number": 1234567890,
            "Email_address": "tim@bruins.com",
            "Address_lines": ["123 Main St"],
            "City": "Burlington",
            "State_province_county": "VT",
            "Country": "USA",
            "Other_passenger_details": "Generic details about Tim",
            "Itinerary_reservations": [
                1
            ]
        },
        {
            "Passenger_id": 2,
            "First_name": "Jeremy",
            "Second_name": "Jeremiah",
            "Last_name": "Swayman",
            "Phone_number": 9876543210,
            "Email_address": "jeremy@bruins.com",
            "Address_lines": ["456 Causeway St"],
            "City": "Boston",
            "State_province_county": "MA",
            "Country": "USA",
            "Other_passenger_details": "Generic details about Jeremy",
            "Itinerary_reservations": [
                2 
            ]
        },
    ],
    "Itinerary_reservations": [
        {
            "Reservation_id": 1,
            "Agent_id": 1,
            "Passenger_id": 1,
            "Reservation_status_code": 301,
            "Ticket_type_code": 401,
            "Travel_class_code": 501,
            "Date_reservation_made": "2023-09-21",
            "Number_in_party": 2,
            "Ref-calendar": 1,
            "reservation_payments": 1,
            "Itinerary_legs": [
                1,
            ]
        },
        {
            "Reservation_id": 2,
            "Agent_id": 2,
            "Passenger_id": 2,
            "Reservation_status_code": 302,
            "Ticket_type_code": 402,
            "Travel_class_code": 502,
            "Date_reservation_made": "2023-09-23",
            "Number_in_party": 1,
            "Ref-calendar": 2,
            "reservation_payments": 2,
            "Itinerary_legs": [
                2,
            ]
        },
    ],
    "Ref_calendar": [
        {
            "day_date": "2023-09-21",
            "day_number": 1,
            "business_day_yn": True,
            "Payments": 1
        },
        {
            "day_date": "2023-09-23",
            "day_number": 2,
            "business_day_yn": False,
            "Payments": 2
        },
    ],
    "Payments": [
        {
            "Payment_id": 1,
            "Payment_status_code": 101,
            "Payment_date": "2023-09-21",
            "Payment_amount": 100.00,
            "reservation_payments": [1],
            "Flight_costs": [1, 2]
        },
        {
            "Payment_id": 2,
            "Payment_status_code": 102,
            "Payment_date": "2023-09-23",
            "Payment_amount": 150.00,
            "reservation_payments": [2],
            "Flight_costs": [2]
        },
    ],
    "Flight_costs": [
        {
            "Flight_number": 101,
            "Aircraft_type_code": 201,
            "valid_from_date": "2023-09-21",
            "valid_to_date": "2023-09-30",
            "flight_cost": 200.00,
            "Flight_schedules": [1]
        },
        {
            "Flight_number": 102,
            "Aircraft_type_code": 202,
            "valid_from_date": "2023-09-21",
            "valid_to_date": "2023-09-30",
            "flight_cost": 250.00,
            "Flight_schedules": [2]
        },
    ],
    "Flight_schedules": [
        {
            "Flight_number": 101,
            "Airline_code": 1001,
            "Usual_aircraft_type_code": 201,
            "Origin_airport_code": "BOS",
            "Destination_airport_code": "LAX",
            "Departure_date_time": "2023-09-21 08:00:00",
            "Arrival_date_time": "2023-09-21 10:00:00",
            "Airports": [1],
            "Legs": [1] 
        },
        {
            "Flight_number": 102,
            "Airline_code": 1002,
            "Usual_aircraft_type_code": 202,
            "Origin_airport_code": "LAX",
            "Destination_airport_code": "BOS",
            "Departure_date_time": "2023-09-23 09:00:00",
            "Arrival_date_time": "2023-09-23 11:00:00",
            "Airports": [2],
            "Legs": [2] 
        },
    ],
    "Airports": [
        {
            "airport_code": "BOS",
            "airport_name": "Logan",
            "airport_location": "Boston",
            "other_details": "Generic details about BOS",
            "Legs": [1],
        },
        {
            "airport_code": "LAX",
            "airport_name": "Los Angeles International",
            "airport_location": "Los Angeles",
            "other_details": "Generic details about LAX",
            "Legs": [2],
        },
    ],
    "Legs": [
        {
            "Leg_id": 1,
            "Flight_number": 101,
            "Origin_airport": "BOS",
            "Destination_airport": "LAX",
            "Actual_departure_time": "2023-09-21 09:00:00",
            "Actual_arrival_time": "2023-09-21 11:00:00",
            "Itinerary_legs": 1, 
        },
        {
            "Leg_id": 2,
            "Flight_number": 102,
            "Origin_airport": "LAX",
            "Destination_airport": "BOS",
            "Actual_departure_time": "2023-09-23 09:00:00",
            "Actual_arrival_time": "2023-09-23 11:00:00",
            "Itinerary_legs": 2,  
        },
    ],
    "Booking_agents": [
        {
            "Agent_id": 1,
            "Agent_name": "Jon Jones",
            "Agent_details": "Generic details about Jon Jones",
        },
        {
            "Agent_id": 2,
            "Agent_name": "Daniel Cormier",
            "Agent_details": "Generic details about Daniel Cormier",
        },
    ],
    "Itinerary_legs": [
        {
            "Reservation_id": 1,
            "Leg_id": 1,
            "Flight_number": 102
        },
        {
            "Reservation_id": 2,
            "Leg_id": 2,
            "Flight_number": 101
        },
    ]
}


collection = db["AirlineData"]
collection.insert_one(data_model)

