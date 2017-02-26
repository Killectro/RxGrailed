# RxGrailed

This app is an infinitely scrolling Rx-ified implementation of a basic Grailed feed. This uses the public listing API exposed through [Algolia](https://www.algolia.com/doc/api-client/swift/getting-started/). To download and open the project, simply run the following commands:

```sh
git clone git@github.com:Killectro/RxGrailed.git
cd RxGrailed/RxGrailed
open RxGrailed.xcworkspace/
```

## Dependencies

This app uses a few primary dependencies to simplify the implementation and abstract away some pesky details such as asynchronous networking, image retrieval, and JSON mapping:

- [RxSwift/RxCocoa](https://github.com/ReactiveX/RxSwift/): Abstract away gritty details of asynchronous programming (and much much more)
- [Kingfisher](https://github.com/onevcat/Kingfisher): Cleanly and simply download and decode images
- [ModelMapper](https://github.com/lyft/mapper): Simple interface for defining JSON to model mappings

## Architecture

RxGrailed uses a slightly modified version of a protocol-oriented MVVM architecture. Each View or ViewController owns a ViewModel that contains the business logic for calculating what to display on the screen. The methods and properties necessary to display a particular view are exposed through a protocol that the ViewModel conforms to. Views and ViewControllers only hold a reference to that protocol, effectively hiding the business logic and implementation details from the view layer. Wherever API communication is required, that logic is split out of the ViewModel into a NetworkModel. All ViewController initialization and presentation logic is contained in `Coordinator` objects.
