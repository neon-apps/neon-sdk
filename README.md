
# NeonSDK

NeonSDK is a powerful software development kit designed to enhance the efficiency of iOS app development. By utilizing NeonSDK, developers can create exceptional apps in significantly less time, resulting in an overall better end-user experience.


## Table of Contents

- [Configure NeonSDK](#Configure-NeonSDK)
- [Firebase Managers](#Firebase-Managers)
    - [FirestoreManager](#FirestoreManager)
         - [Manage Documents](#Manage-Documents)
           - [Create a Document with Fields](#Create-a-Document-with-Fields)
           - [Create a Document with Object](#Create-a-Document-with-Object)
           - [Update a Document with Fields](#Update-a-Document-with-Fields)
           - [Delete a Document with Fields](#Delete-a-Document-with-Fields)
        - [Get Documents](#Get-Documents)
            - [Get a Document](#Get-a-Document)
            - [Get All Documents in a Collection](#Get-All-Documents-in-a-Collection)
            - [Get a Document as Object](#Get-a-Document-as-Object)
            - [Get All Documents in a Collection as Object](#Get-All-Documents-in-a-Collection-as-Object)
        - [Listen Documents](#Listen-Documents)
            - [Listen a Document](#Listen-a-Document)
            - [Listen All Documents in a Collection](#Listen-All-Documents-in-a-Collection)
    - [RemoteConfigManager](#RemoteConfigManager)
        - [Configure Remote Config](#Configure-Remote-Config)
        - [Fetch Remote Config Values](#Fetch-Remote-Config-Values)
- [CoreDataManager](#CoreDataManager)
    - [Save Data](#Save-Data)
    - [Update Data](#Update-Data)
    - [Delete Data](#Delete-Data)
    - [Fetch Data](#Fetch-Data)
- [LottieManager](#LottieManager)
    - [Show Full-Screen Lottie](#Show-Full-Screen-Lottie)
    - [Remove Full-Screen Lottie](#Remove-Full-Screen-Lottie)
    - [Add Lottie to Specific Location](#Add-Lottie-to-Specific-Location)
- [RevenueCatManager](#RevenueCatManager)
    - [Configure RevenueCat](#Configure-RevenueCat)
    - [Select Package](#Select-Package)
    - [Subscribe to Selected Package](#Subscribe-to-Selected-Package)
    - [Purchase Selected Package](#Purchase-Selected-Package)
    - [Restore Subscriptions](#Restore-Subscriptions)
## Configure NeonSDK


```swift
Neon.configure(
    window: &window,
    onboardingVC: Onboarding1VC(),
    paywallVC: PaywallVC(),
    homeVC: HomeVC())
```

The ```Neon.configure``` function is used to set up and configure the ```NeonSDK``` framework for use in your app. It takes four parameters:

window: a reference to the app's main window.

```onboardingVC```: the first view controller that should be displayed during onboarding.

```paywallVC```: the view controller that should be displayed when a user is prompted to pay for premium features.

```homeVC```: the view controller that should be displayed once the user has completed onboarding and/or paid for premium features.

This function should be called in the ```AppDelegate```'s ```didFinishLaunchingWithOptions``` method. Once configured, ```NeonSDK``` will handle the user flow between these different view controllers based on their authentication and subscription status.
#  Firebase Managers

Firebase Managers is a collection of manager classes that provides a streamlined interface for handling various Firebase services such as Authentication, Cloud Storage, Cloud Firestore, Remote Config, and more. These manager classes encapsulate the complexity of Firebase APIs and provide a simple and intuitive API for developers to work with Firebase services. Using Firebase Managers, developers can easily integrate Firebase services into their applications and build robust and scalable Firebase-powered apps.
# FirestoreManager

The FirestoreManager class simplifies the management of Firebase Firestore operations, providing a more efficient and streamlined approach.

## Manage Documents

### Create a Document with Fields 

To create a document in a particular collection with specific properties, utilize the FirestoreManager.setDocument function and provide the necessary field values through the "fields" parameter.

```swift
  FirestoreManager.setDocument(path: [
        .collection(name: "first collection"),
        .document(name: "first document"),
    ], fields: [
        "string" : "string",
        "int" : 7,
        "bool": true
    ])
```

It's important to note that the path provided in this function should conclude with the ".document()" method to accurately specify the targeted document in the Firestore database.

### Create a Document with Object

To create a document in a particular collection with an instance of class object, utilize the FirestoreManager.setDocument function and provide the necessary instance through the "object" parameter.

```swift
    FirestoreManager.setDocument(path: [
        .collection(name: "first collection"),
        .document(name: "first document")
    ], object: city)
```

In order to use the instance of a class and its subclasses within this function, it's necessary for the class to be Codable. To achieve this, simply declare the class with the Codable protocol, like so: "class City: Codable{}".

```swift
public class City: Codable {
    internal init(name: String, state: String? = nil, country: [Country]? = nil, isCapital: Bool? = nil, population: Int64? = nil) {
        self.name = name
        self.state = state
        self.country = country
        self.isCapital = isCapital
        self.population = population
    }
    let name: String
    let state: String?
    let country: [Country]?
    let isCapital: Bool?
    let population: Int64?
}

public class Country: Codable {
    internal init(name: String, size: Int? = nil) {
        self.name = name
        self.size = size
    }
    let name: String
    let size: Int?
}

    let country1 = Country(name: "Vegas", size: 10000)
    let country2 = Country(name: "San Diego", size: 5466)
    let country3 = Country(name: "San Fransisco", size: 3432)
    
    let city = City(name: "Los Angeles",
                    state: "CA",
                    country: [country1, country2, country3],
                    isCapital: false,
                    population: 5000000)
    
```

It's important to note that the path provided in this function should conclude with the ".document()" method to accurately specify the targeted document in the Firestore database.

### Update a Document with Fields

To update a document in a particular collection with specific properties, utilize the FirestoreManager.updateDocument function and provide the necessary field values through the "fields" parameter.

```swift
     FirestoreManager.updateDocument(path: [
        .collection(name: "first collection"),
        .document(name: "first document")
    ], fields: [
        "int" : 9
    ])
```

This function is only applicable to an existing document located at the specified path, as it cannot function without an existing document. It can either modify an existing field or create a new field within the document as needed.

### Delete a Document

To update a delete in a particular collection, utilize the FirestoreManager.deleteDocument function and provide the necessary path through the "path" parameter.

```swift
     FirestoreManager.deleteDocument(path: [
        .collection(name: "first collection"),
        .document(name: "first document")
    ])
```
## Get Documents

### Get a Document 

To retrieve a single document at a specific path, the FirestoreManager.getDocument function can be utilized. This function returns both the document ID as a ```String```, and all of its fields as a dictionary of ```[String:Any]```.

```swift
    FirestoreManager.getDocument(path: [
        .collection(name: "first collection"),
        .document(name: "first document")
    ], completion: { documentID, documentData  in
        let country = documentData["country"]
    })
```

Upon obtaining the document data through the completion handler, the desired field can be accessed by referencing its corresponding key using the syntax: ```documentData["field-key"]```.

### Get All Documents in a Collection

To retrieve all documents from a specific collection, the FirestoreManager.getDocuments function can be used. This function returns both the document ID as a ```String``` and all its fields as a dictionary of ```[String:Any]``` for each document found. The completion handler will be executed for each object returned.

```swift
    FirestoreManager.getDocuments(path: [
        .collection(name: "first collection"),
        .document(name: "first document"),
        .collection(name: "second collection"),
    ], completion: { documentID, documentData  in
        let country = documentData["country"]
    })
```

Upon obtaining the document data through the completion handler, the desired field can be accessed by referencing its corresponding key using the syntax: ```documentData["field-key"]```.

It's important to note that the Path array provided to this function must end with a collection instance, as this function returns all documents within a specified collection.

### Get a Document as Object

The FirestoreManager.getDocument function can be utilized to retrieve a single document as an object of a specified class type, by passing in the class type as the "objectType" parameter. For example, if you want to fetch an instance of a specific class, you would provide the class type like so: ```Class.Type```. 

```swift
     FirestoreManager.getDocument(path: [
        .collection(name: "first collection"),
        .document(name: "first document")
    ], objectType: City.self) { object in
        if let city = object as? City{
            print(city.country)
        }
    }
```

If the specified class can be instantiated using the fields of the document located at the provided path, this function will return the instantiated object in the completion handler. To safely unwrap the returned object, use the syntax ```if let instance = object as? Class``` and then access the object's properties as needed. For example:
```swift
if let city = returnedObject as? City {
    print(city.name)
}
```

### Get All Documents in a Collection as Object

The FirestoreManager.getDocuments function can be utilized to retrieve all documents from a specific collection as an object of a specified class type, by passing in the class type as the "objectType" parameter. 

```swift
  FirestoreManager.getDocuments(path: [
        .collection(name: "first collection"),
        .document(name: "first document"),
        .collection(name: "second collection"),
    ], objectType: City.self) { object in
        if let city = object as? City{
            print(city.country)
        }
    }
```

If the fields of the documents within a specified collection can be used to instantiate an object of the specified class, this function will return the instantiated objects through the completion handler. The completion handler will be executed for each object returned.

To safely unwrap the returned objects, use the syntax ```if let instance = object as? Class``` and then access the object's properties as needed. For example:
```swift
if let city = returnedObject as? City {
    print(city.name)
}
```
It's important to note that the Path array provided to this function must end with a collection instance, as this function returns all documents within a specified collection.

## Listen Documents

### Listen a Document

The FirestoreManager.listenDocument function can be used to actively monitor changes in a specific document. The completion handler for this function will be executed whenever any field of the specified document is changed, returning the updated version of the document and the source that initiated the change.

```swift
  FirestoreManager.listenDocument(path: [
        .collection(name: "first collection"),
        .document(name: "first document")
    ], completion: { updatedDocumentData, source   in
        
    })
```
By accessing the "source" variable returned by the function and utilizing a switch case statement, you can determine whether the change originated from the local user or the server.
```swift
    switch source{
    case .server :
        break
    case .local :
        break
    }
```
It's important to note that when this function is initialized, it will execute once even if no changes are present, and return the data of the document being monitored for changes.

### Listen All Documents in a Collection

The FirestoreManager.listenDocuments function can be utilized to actively monitor changes in all documents located within a specific collection. Whenever a field is modified, a document is added or removed, the completion handler will be executed, returning the document ID, the updated version of the document, the source that initiated the change, and the type of change that occurred.

```swift
  FirestoreManager.listenDocuments(path: [
        .collection(name: "first collection"),
        .document(name: "first document"),
        .collection(name: "second collection")
    ], completion: { documentID, updatedDocumentData, source, changeType in
        
    })
```
Utilizing a switch case statement on the "changeType" variable returned by the function allows you to differentiate between the three types of changes: addition, modification, or removal of a document.

```swift
    switch changeType{
    case .added :
        break
    case .modified :
        break
    case .removed :
        break
    }
```
By accessing the "source" variable returned by the function and utilizing a switch case statement, you can determine whether the change originated from the local user or the server.
```swift
    switch source{
    case .server :
        break
    case .local :
        break
    }
```

# RemoteConfigManager

The FirebaseRemoteConfigManager class provides an interface for managing remote configuration values in a Firebase project. With this class, developers can fetch and apply configuration changes in real-time without requiring app updates, making it easy to customize the behavior and appearance of an app without the need for a code change. 

## Configure Remote Config

The ```RemoteConfigManager.configureRemoteConfig``` function initializes the Firebase Remote Config service with the specified default values for the remote configuration parameters. This function creates a new instance of the Firebase Remote Config service and sets the default values for each parameter, as specified in the ```defaultValues``` parameter.

```swift
RemoteConfigManager.configureRemoteConfig(defaultValues: [
    "stringValue" : "String" as NSObject,
    "boolValue" : false  as NSObject,
    "integerValue" : 5  as NSObject,
    "doubleValue" : 5.3  as NSObject,
    "arrayValue" : [1,2,3]  as NSObject
    ])
```
Note that the defaultValues parameter should be a dictionary with keys corresponding to the names of the remote configuration parameters and values of type NSObject, which can be of any supported type such as String, Bool, Int, Double, or Array.

## Fetch Remote Config Values

The ```RemoteConfigManager.getInt```, ```RemoteConfigManager.getDouble```, ```RemoteConfigManager.getBool```, ```RemoteConfigManager.getData```, and ```RemoteConfigManager.getArray``` functions retrieve the current values of specified remote configuration parameters from the Firebase Remote Config service. These functions retrieve the current value of the specified parameter from the Firebase Remote Config service and return it as a value of the appropriate type.

```swift
let integerValue = RemoteConfigManager.getInt(key: "integerValue")
let doubleValue = RemoteConfigManager.getDouble(key: "doubleValue")
let boolValue = RemoteConfigManager.getBool(key: "boolValue")
let dataValue = RemoteConfigManager.getData(key: "dataValue")
let arrayValue = RemoteConfigManager.getArray(key: "arrayValue")
```

Note that each of these functions should be called with a ```key``` parameter corresponding to the name of the remote configuration parameter to retrieve, and the returned value should be safely cast to the appropriate type. If the parameter does not exist or has not yet been fetched, the default value for that parameter will be returned.
# CoreDataManager

The CoreDataManager class provides a simplified interface for performing common CoreData operations, thereby reducing the complexity of managing CoreData in an application.

## Save Data

The ```CoreDataManager.saveData``` function saves a new object of a specified entity type in the specified container with the provided attribute values. This function is particularly useful for simplifying the process of adding new objects to a CoreData database.

```swift
CoreDataManager.saveData(container: "CoreData",
                        entity: "City",
                        attributeDict: ["name" : "Los Angeles",
                                        "id" : "1",
                                        "population" : 700000
                                        ])
```

Note that the entity type and container must already exist in the database for this function to work properly. Additionally, the ```attributeDict``` parameter must include values for all required attributes of the specified entity type.

## Update Data

The ```CoreDataManager.updateData``` function updates an existing object of a specified entity type in the specified container with new attribute values. This function locates the object using the provided ```searchKey``` and ```searchValue``` parameters, and replaces its attribute values with the new values specified in the ```newAttributeDict``` parameter.

```swift
CoreDataManager.updateData(container: "CoreData",
                            entity: "City",
                            searchKey: "id",
                            searchValue: "1",
                            newAttributeDict: ["name" : "Los Angeles",
                                                "state" : "CA",
                                                "id" : "1",
                                                "population" : 700000
                                                ])
```
Note that the entity type and container must already exist in the database for this function to work properly. Additionally, the ```searchKey``` parameter must correspond to a unique attribute of the specified entity type, and ```searchValue``` must match the value of this attribute in the object to be updated and it should be a ```String```. Finally, ```newAttributeDict``` must include values for all attributes that need to be updated in the object.

## Delete Data



The ```CoreDataManager.deleteData``` function removes an existing object of a specified entity type from the specified container. This function locates the object using the provided ```searchKey``` and ```searchValue``` parameters, and removes it from the database.

```swift
CoreDataManager.deleteData(container: "CoreData",
                            entity: "City",
                            searchKey: "id",
                            searchValue: "1")
```

Note that the entity type and container must already exist in the database for this function to work properly. Additionally, the ```searchKey``` parameter must correspond to a unique attribute of the specified entity type, and ```searchValue``` must match the value of this attribute in the object to be deleted and it should be a ```String```.

## Fetch Data

The ```CoreDataManager.fetchDatas``` function retrieves all objects of a specified entity type from the specified container and executes a closure with each fetched object. This function retrieves all attribute values of each object and passes them as a dictionary to the closure.

```swift
CoreDataManager.fetchDatas(container: "CoreData", entity: "City") { data in
    if let cityName = data.value(forKey: "name") as? String {
        
    }
    if let population = data.value(forKey: "population") as? Int {
        
    }
}
```
Note that the entity type and container must already exist in the database for this function to work properly. Additionally, the closure should handle the retrieved data by casting each attribute value to its appropriate type, such as String or Int, as shown in the example code provided.

# LottieManager

The LottieManager class provides a convenient way to work with Lottie animations in an application. With LottieManager, developers can easily load and display Lottie animations in their apps.

## Show Full-Screen Lottie

The ```LottieManager.showFullScreenLottie``` function displays a Lottie animation in full screen. This function accepts three optional parameters:

```swift
LottieManager.showFullScreenLottie(animation: .loadingLines2, color: .blue, backgroundOpacity: 0)
LottieManager.showFullScreenLottie(animation: .loadingLines, color: .clear)
LottieManager.showFullScreenLottie(animation: .custom(name: "myCustomAnimation"))
```

```animation```: This parameter specifies the Lottie animation to display. It can either be a pre-defined animation provided by the NeonSDK, such as ```.loadingLines```, or a custom animation specified by name.

```color```: This parameter sets the color of the Lottie animation. It can be set to any UIColor value, or set to .clear to display the animation with it's original color.

```backgroundOpacity```: This parameter sets the opacity of the background behind the Lottie animation. It accepts a value between 0 and 1, where 0 is fully transparent and 1 is fully opaque.

## Remove Full-Screen Lottie

The ```LottieManager.removeFullScreenLottie``` function removes the currently displayed full screen Lottie animation, if any, from the screen. This function does not accept any parameters and simply removes the Lottie animation from the screen.

```swift
LottieManager.removeFullScreenLottie()
```
## Add Lottie to Specific Location

The ```LottieManager.createLottie``` function creates and returns a Lottie animation with the specified animation. This function accepts one parameter:

```animation```: This parameter specifies the Lottie animation to display. It can either be a pre-defined animation provided by the NeonSDK, such as ```.loadingCircle3```, or a custom animation specified by name with the syntax ```.custom(name: "myCustomAnimation")```.

```swift

// Add Lottie to specific location
         
let lottie = LottieManager.createLottie(animation: .loadingCircle3)
view.addSubview(lottie)
lottie.snp.makeConstraints({make in
    make.top.left.height.width.equalTo(100)
})
             
// Add Custom Lottie to specific location
         
let lottie2 = LottieManager.createLottie(animation: .custom(name: "myCustomAnimation"))
view.addSubview(lottie2)
lottie2.snp.makeConstraints({make in
    make.top.left.height.width.equalTo(100)
})
```
The returned Lottie animation view can then be added to a specific location within a view hierarchy using the addSubview method. Once added, it can be positioned using Auto Layout constraints, such as those created with the SnapKit library as shown in the example.

Note that once the Lottie animation view is created, it can be customized further using properties such as loopMode, animationSpeed, and background color.


# RevenueCatManager

The RevenueCatManager class provides a simple interface for managing in-app purchases and subscriptions in an application using the RevenueCat SDK. With RevenueCatManager, developers can easily integrate RevenueCat into their application and handle subscription-related tasks such as purchase validation, receipt management, and user entitlements.

## Configure RevenueCat


```swift
RevenueCatManager.configure(withAPIKey: "YOUR_API_KEY", products : [
    "WEEKLY_PRODUCT_ID", 
    "MONTHLY_PRODUCT_ID", 
    "ANNUAL_PRODUCT_ID", 
    "CUSTOM_PRODUCT_ID"
])
```
  
The ```RevenueCatManager.configure``` function configures the RevenueCat SDK with the provided API key and product identifiers. This function accepts two parameters:

```withAPIKey```: This parameter specifies the API key for your RevenueCat account. This is a required parameter and must be provided.
```products```: This parameter specifies an array of product identifiers that correspond to the in-app purchases defined in your RevenueCat account. 

IMPORTANT NOTE! : The entitlement id in your RevenueCat dashboard should be "pro".

## Fetch Prices

Implement the ```RevenueCatManagerDelegate``` protocol in your ```ViewController``` and set the delegate to self to receive package fetch events. You can then retrieve the localized price string for a specific package by calling the ```getPackagePrice``` method with the package ID. Similarly, you can retrieve the entire package object by calling the ```getPackage``` method with the package ID. 

```swift
class ViewController: UIViewController, RevenueCatManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        RevenueCatManager.delegate = self
        packageFetched()

    }

    func packageFetched() {
        
        if let price = RevenueCatManager.getPackagePrice(id: "MONTHLY_PRODUCT_ID"){
            let monthlyPackagePrice = price
        }
        
        if let monthlyPackage = RevenueCatManager.getPackage(id: "MONTHLY_PRODUCT_ID"){
            let price = monthlyPackage.localizedPriceString
        }
        
    }
}
```

Please note that you should call the ```packageFetched``` function in the ```viewDidLoad``` method. By doing so, you will receive the latest fetched price from ```UserDefaults``` before fetching packages.

## Select Package

The ```RevenueCatManager.selectPackage``` function allows you to select a specific package for purchase or subscribe. Simply provide the ID of the package you wish to select as the id parameter. 

```swift
func weeklyClicked(){
    RevenueCatManager.selectPackage(id: "WEEKLY_PRODUCT_ID")
}
```
This function should be called after successfully configuring RevenueCat and fetching the available packages, and before initiating the purchase process.

## Subscribe to Selected Package

The ```RevenueCatManager.subscribe``` function allows you to initiate the subscription process for the selected package. You can pass a Lottie animation to display during the subscription process, and provide completion blocks for both successful and failed purchase attempts.

In the ```completionSuccess block```, you can handle the successful subscription purchase as needed. In the ```completionFailure``` block, you can handle any errors that may occur during the subscription process.

```swift
RevenueCatManager.subscribe(animation: .loadingBar) {
    // Subscribed to selected package succesfully
} completionFailure: {
    // Couldn't subscribe to selected package
}
```
In the ```RevenueCatManager.subscribe``` function, ```animationColor``` and ```animationWidth``` are optional parameters that can be used to customize the loading animation displayed during the subscription process.
```swift
RevenueCatManager.subscribe(animation: .loadingBar, animationColor : .red, animationWidth: 100)
```
```animationColor```specifies the color of the loading animation. If not provided, the default color will be used.

```animationWidth``` specifies the width of the loading animation. If not provided, the default width will be used.

## Purchase Selected Package

The ```RevenueCatManager.purchase``` function can be used to purchase both consumable and non-consumable packages. It can't be used for subscriptions.

```swift
RevenueCatManager.purchase(animation: .loadingBar) {
    // Selected package purchased succesfully
} completionFailure: {
    // Couldn't purchase selected package
}
        
```

For consumable packages, the purchased product is something that can be used up and needs to be purchased again in the future. An example of this type of package could be virtual coins in a game.

For non-consumable packages, the purchased product is something that is permanently available to the user after purchase. An example of this type of package could be a lifetime subscription to a news app.

The function will trigger the appropriate behavior based on the type of package being purchased.

## Restore Subscriptions

The ```RevenueCatManager.restorePurchases``` function is used to restore any previously purchased subscriptions made by the user on a different device or after re-installing the app.

```swift
RevenueCatManager.restorePurchases(vc: self, animation: .loadingBar) {
    // Subscription restored succesfully
} completionFailure: {
    // Couldn't find any active subscription
}
```

The function takes in the current view controller, animation parameter to show a loading animation while the process is running, and two completion blocks to handle success and failure cases respectively.

```swift
RevenueCatManager.restorePurchases(vc: self, animation: .loadingBar, showAlerts: false)
```

The ```showAlerts``` parameter is an optional parameter that defaults to true. When it is set to true, the user will see alert messages indicating whether the restore was successful or failed. 

If you want to hide these alerts and handle the result of the restore programmatically, you can set ```showAlerts``` to false. This can be useful if you want to provide your own UI for handling restore results or if you want to perform some additional logic before showing the alerts to the user.