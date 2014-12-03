0d1g30
======
This app uses Core Data, GDC for Asynchronos background Tasks, Autolayout, XCTTest, among other iOs technologies.

The app takes its resources from two web services that provide massive amounts of data. That's why Core Data is a good approach to resolve background syncronization, persistance, and especially efficient to perform queries .

Basically, I decided to use coredata because  the webservice data is consumed by the app as collections of elements, the  'NSFetchResultController' gives a lot of work done in order to create the table views.

With respect to the TableView Controllers, I decided to seperate the DataSource in a different Class 'FetchedResultsControllerDataSource' in order to reuse it in all the table view. And also use inheritance in order to make the classes as short as possible. 


The design I used to implement CoreData is based in two "NSManagedObjectContext" one for the UI (main thread) operations, and a worker for the fetchs and all the heavy work . They are both synchroniced in order to mantain the integrety of the model's graph. That work is implemented in 'FCPCoreDataStore'.  The prefix FCP stands for my initials, and is based on a previos app I coded. 
I also try to show how I like to structure the project , in folders that express the design patterns I've used.

Finally, I used TDD to develop some of the CoreData Queries, and to test the 'HomeViewController'. Since one of the requirements was to not use third party libraries, I decided to make my own mocking classes using the runtime library objc/runtime.h. In this case I also used my own code snipet (XCTestCase+FCPHelper.h) to make my life easier, but In production code, probably i would have used Mockito and Hamcrest for iOS.




TODO: the app stores all the data requests to the server.. There is no delete policy programmed .. Just delete the app , to remove all the objects...

Distribute and enjoy !!