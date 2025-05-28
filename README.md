# Forcaster.app
The repository serves to host the Forecaster App which uses the iPhone's current location to retrieve the weather and the core data to CRUD data.

Below is a quick guide to installation, happy/sad day scenarios and general information.

# Insallation
No additional software installation is required.

# Minimum requirements:
- Xcode Version 16.1 (16B40)
- Simulator device: iPhone 16 | iOS 18.1 
- (Location Permissions required and requested)
- CoreData will be accessed

# Visual Guide
To help generate the required sceens

# Locations on & CoreData populated

<img src="https://github.com/user-attachments/assets/dd3cdb55-621c-444e-ae05-2e862be88253" width=25% height=25%>
<img src="https://github.com/user-attachments/assets/14a885a1-6300-488f-9989-116ecff9a660" width=25% height=25%>
<img src="https://github.com/user-attachments/assets/fda78028-15d6-47ae-a326-51ead8be8818" width=25% height=25%>
<img src="https://github.com/user-attachments/assets/4c5f59fd-8f4d-4d20-92e6-09de789f635f" width=25% height=25%>
<img src="https://github.com/user-attachments/assets/a47f0592-ced0-4cd2-b1d4-54ae5187afd2" width=25% height=25%>
<img src="https://github.com/user-attachments/assets/77dec134-ff7a-4d11-892a-49c40f551a5d" width=25% height=25%>

# Known Issues:
- Intermittent: permissions request upon first launch cause screen/loader to hang on launch
- Offline user selecting map view and back to WeatherView
- Intermittent: Navigation from MapView to WeatherView causes infinite loader
- Intermittent: ErrorView on WeatherView (when location services are denied)
- Intermittent: some MapKit locations on incorrect positions on map

# Improvements
- Handling ErrorView scenarios
- GMSPlaces (feat/map) introduced and viewed but not enough time to tackle formatting, placing and mapkit integration [Improvement]
- More Unit tests via mocking locations [Improvements]

# Used Resources:
- MapKit - https://www.hackingwithswift.com/books/ios-swiftui/integrating-mapkit-with-swiftui
- Quicktype (for model generation) - https://app.quicktype.io/
