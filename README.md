MyPlace

MyPlace is an iOS application that allows users to add and save their favorite locations with various details. 
The app uses MapKit to enable location selection on the map and provides routing from the user’s current location to a selected place.

Features

	•	Add Locations: Users can add new places with the following details:
	•	Name
	•	Type (e.g., restaurant, park, landmark)
	•	Address
	•	Rating
	•	Map View: Displays user-selected locations on the map with annotations using MapKit.
	•	Route Building: Allows users to build a route from their current location to the selected place.

Project Structure

	•	Helper: Contains helper classes like AnnotationViewFactory for customizing annotation views.
	•	Models: Includes data models, such as PlaceAnnotation and PlaceModel, to handle location data.
 
	•	Services: Manager classes such as:
	•	AnnotationManager
	•	DirectionsManager
	•	RatingControl
	•	StorageManager > REALM
	•	UserLocationManager
 
	•	ViewControllers: Main view controllers, including:
	•	MainViewController - the main screen with a list of added places.
 ![image](https://github.com/user-attachments/assets/1919193a-880a-4d64-bd7d-e633eadf4ef9)

 
	•	MapViewController - map view for selecting locations.
 ![image](https://github.com/user-attachments/assets/12fe7efe-0131-43b9-8341-be7ee33ce531)
 ![image](https://github.com/user-attachments/assets/b580faca-a5e0-4a62-8f5d-0c1e0be96144)


	•	NewPlaceTableViewController - screen for adding a new location.
![image](https://github.com/user-attachments/assets/02ff2eff-a3ad-4b6a-96ae-907ea5de79c4)
![image](https://github.com/user-attachments/assets/44b0e899-21b4-412f-affd-04f6e6b57bd8)


Installation

	1.	Clone the repository:

[git clone <URL>](https://github.com/IgorOK96/MyPlace-UIKit.git)


	2.	Open the project in Xcode.
	3.	Build and run the project on a simulator or device.

Technologies Used

	•	Swift
	•	MapKit: for map functionality and routing
	•	UIKit: for building the user interface
	•	CoreLocation: for retrieving the user’s location

Future Updates

	•	Add the ability to edit and delete saved locations.
	•	Support for favorite places and filters by location types.
