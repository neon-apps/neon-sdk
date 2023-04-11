
# NeonSDK

NeonSDK is a powerful software development kit designed to enhance the efficiency of iOS app development. By utilizing NeonSDK, developers can create exceptional apps in significantly less time, resulting in an overall better end-user experience.


## Contents

- [FirestoreManager](#FirestoreManager)
    - [Create a Document with Fields](#usage)
    - [Create a Document with Object](#credits)
    - [Update a Document with Fields](#license)
    - [Delete a Document with Fields](#license)
## FirestoreManager

The FirestoreManager class simplifies the management of Firebase Firestore operations, providing a more efficient and streamlined approach.

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


