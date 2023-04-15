
# NeonSDK

NeonSDK is a powerful software development kit designed to enhance the efficiency of iOS app development. By utilizing NeonSDK, developers can create exceptional apps in significantly less time, resulting in an overall better end-user experience.


## Table of Contents

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
- [CoreDataManager](#CoreDataManager)
    - [Save Data](#Save-Data)
    - [Update Data](#Update-Data)
    - [Delete Data](#Delete-Data)
    - [Fetch Data](#Fetch-Data)
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
