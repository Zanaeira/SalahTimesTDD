# Salāh Times App

This App is primarily a portfolio piece to demonstrate good practices and iOS / Swift skills. You can find below a summary of the various things included in this project. The below list is not exhaustive, but shows a nice range of the skills and techniques I would like to demonstrate in this app.

## Architecture

This app attempts to use good architectural practices, as mentioned below.

### MVC

The app is coded using an MVC approach. The simplicity of the app, and focus on trying to make appropriate architectural choices based on the current requirements, meant that there was no need to superficially implement a different architecture such as MVVM or MVP. MVC was very suitable and clean and hence I did not opt for any alternative.

### Design Patterns

The app uses design patterns such as delegation and observers (NotificationCenter).

### Modularity

The app is modular in a number of ways. The project is split into a framework and a main app. The framework consists of a number of targets to help modularise the different components. This necessitated sensible and reasonable use of access modifiers in order to keep internal and private details safely away from the main app / other components.

The framework has targets for
1. The Networking layer
2. The Unit tests for the Networking layer
3. The end-to-end tests for the Networking layer
4. The iOS target - iOS specific components / view controllers that speak to the Networking layer via its public interface / API and without any access to its internal implementation details

The main app serves as the Composition Root in which the iOS App is brought together in a UITabBarController.

### Dependency Injection

In the Composition Root, the dependencies are injected into the view controllers instead of relying on global Singletons. For example, instead of using UserDefaults.standard everywhere in the application, or URLSession.shared, instances of UserDefaults and URLSession are configured and injected in the Composition Root. Thus, no ViewController knows what instance of UserDefaults or URLSession is being used.

This has also allowed me to inject different instances of UserDefaults for different locations. Thus, the user can set specific settings based on a location.

### Protocol-oriented programming

The Networking layer uses protocols to abstract details and thus the usage of URLSession is now simply an implementation detail. This means that adopting a different approach / framework e.g. using Alamofire is as simple as creating a new type that fulfills the requirements of the protocol and injecting this new instance in the Composition Root.

## TDD

The Networking module was all coded using Test-Driven Development.

### Unit tests

Unit tests run on a Mac OS framework to harness the speed of Mac instead of having slow tests running on the simulator.

### End-to-end tests

End-to-end API tests run on a separate target so as not to slow down the unit tests.

## Networking

This app makes a GET request to the API.

### URLSession

The app uses URLSession. However, as an implementation detail, this is hidden behind a protocol. Thus, this app could easily make use of a third-party library if need be.

### URLCache

In the Composition Root, a caching strategy of "load from cache if available, else from the API" is adopted using URLCache. Thus, as long as the user has opened the app once in the day and loaded the times for their preferred location, they will still be able to see the times without internet e.g. underground.

### Codable & JSON

The app makes a GET request to the API and decodes the JSON returned. The API details are kept private in the Networking layer and then mapped to match the model type. In the UI layer, this model is then mapped to match the underlying model for the cells displayed in the UICollectionView. Thus, the model types do not need to conform to Codable and the representation is not tied to the backend API (which could change, or go down), but rather to the needs of the app. The API representation is now just an implementation detail that can be replaced without breaking the rest of the app.

## UserDefaults

The app uses UserDefaults in order to register default settings that can subsequently be overridden by the end user. UserDefaults has been used with both primitives as well as custom object types, using JSON encoding and decoding. UserDefault suites have been used so that users can save location-specific settings. I.e. for whichever locations they have added, they can specify the settings for that location.

## Grand Central Dispatch (GCD)

Other than updating the UI on the main thread, this app makes use of GCD. The Overview screen makes API calls for each location the user has searched for and then displays them all. In order to ensure that the order remains consistent, the app uses DispatchGroup and DispatchSemaphore. Thus, we have a way to synchronously wait for a group of asynchronous API calls to be made, ensuring that the app's state is always consistent.

## Programmatic UIKit

The entire user interface has been coded using programmatic UIKit. Storyboards have not been used at all other than for the launch screen. In order to simulate fast loading, the launch screen is embedded in a UINavigationController with UIBarButtonItems and a UIImageView to mimic the first screen.

### AutoLayout

AutoLayout has been used throughout this App, programmatically. In the launch screen, AutoLayout has been used in the Storyboard.

### Modern Collection Views

The UICollectionView APIs from iOS 13/14 have been used. Namely:
* DiffableDataSource
* CompositionalLayout
* ListCell
* SupplementaryRegistration
* NSCollectionLayoutDecorationItem

### UITableView

The Settings page is a static UITableView.

### UIPageViewController

The app allows users to add multiple locations and displays them in a UIPageViewController.

### UIStackView

This app uses UIStackView which is great for not just laying things out on the screen, but for implementing Dynamic Type support too.

## Accessibility

This app considers accessibility. Namely, dynamic type:

## Dynamic Type

The app supports dynamic type and larger accessibility sizes. The Overview screen reacts to various system font sizes and ensures that the text is always legible. The Locations screen uses UICollectionViewListCell which automatically leverages the in-built support for Dynamic Type.

## NotificationCenter

The app has a minimalistic usage of the NotificationCenter due to the simplicity of its needs. If the system time changes (mainly at midnight, but all if the user changes the date on their device), the app ensures that the prayer times being displayed are up to date by setting the new date and making a new API call.

## Git / Github

I used Git throughout coding this project in order to ensure that changes were incrementally made and that the commited code was always in a working state. I used GitTower and then eventually switched to GitKraken, which I prefer, though am comfortable in using both.
