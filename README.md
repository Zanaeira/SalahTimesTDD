# Salāh Times App

This App is primarily a portfolio piece to demonstrate good practices and iOS / Swift skills. You can find below a summary of the various things included in this project. The below list is not exhaustive, but shows a nice range of the skills and techniques I would like to demonstrate in this app.

## TDD

The Networking module was all coded using Test-Driven Development. Unit tests run on a Mac OS framework to harness the speed of Mac instead of having slow tests running on the simulator. End-to-end API tests run on a separate target so as not to slow down the unit tests.

## Separated project into a framework and main App

The Networking module and iOS-specific contents are in a framework, in separate targets. The App itself is composed in the Composition Root putting the view controllers together into a UITabBarController.

## URLCache

In the Composition Root, a caching strategy of "load from cache if available, else from the API" is adopted using URLCache. Thus, as long as the user has opened the app once in the day and loaded the times for their preferred location, they will still be able to see the times without internet e.g. underground.

## Dependency Injection

In the Composition Root, the dependencies are injected into the view controllers instead of relying on global Singletons. For example, instead of using UserDefaults.standard everywhere in the application, or URLSession.shared, instances of UserDefaults and URLSession are configured and injected in the Composition Root. Thus, no ViewController knows what instance of UserDefaults or URLSession is being used.

## UserDefaults

The app uses UserDefaults in order to register default settings that can subsequently be overridden by the end user. UserDefaults has been used with both primitives as well as custom object types, using JSON encoding and decoding.

## JSON encoding and decoding

The app makes a GET request to the API and decodes the JSON returned. The API details are kept private in the Networking layer and then mapped to match the model type. In the UI layer, this model is then mapped to match the underlying model for the cells displayed in the UICollectionView.

## Protocol-oriented programming

The network layer uses protocols to abstract details and thus the usage of URLSession is now simply an implementation detail. This means that adopting a different approach / framework e.g. using Alamofire is as simple as creating a new type that fulfills the requirements of the protocol and injecting this new instance in the Composition Root.

## Programmatic UIKit

The entire user interface has been coded using programmatic UIKit. Storyboards have not been used at all.

## Modern Collection Views

The UICollectionView APIs from iOS 13/14 have been used. Namely:
* DiffableDataSource
* CompositionalLayout
* ListCell
* SupplementaryRegistration
* NSCollectionLayoutDecorationItem

## MVC

The app is coded using an MVC approach. The simplicity of the app, and focus on trying to make appropriate architectural choices based on the current requirements, meant that there was no need to superficially implement a different architecture such as MVVM or MVP. MVC was very suitable and clean and hence I did not opt for any alternative.

## Dynamic Type

The app supports dynamic type and larger accessibility sizes. Where the largest accessibility sizes would actually cause the text to be less readable and result in a lot of scrolling (namely, on the Settings page), I have restricted the maximum font size. Where iOS 15 is available, I have used the new API to restrict this maximum size to .accessibilityMedium. For iOS 14, I have restricted the maximum size by providing the appropriate font size.

## NotificationCenter

The app has a very minimalistic usage of the NotificationCenter due to the simplicity of its needs. At midnight, the app ensures that the prayer times being displayed are up to date by setting the new date and making a new API call.

