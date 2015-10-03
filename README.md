Honeymoon
=========

A tiny web framework written in Swift 2.0, built on top of [GCDWebServer](https://github.com/swisspol/GCDWebServer) and [GRMustache](https://github.com/groue/GRMustache.swift).

## Usage

Honeymoon itself is heavily inspired by [Flask](http://flask.pocoo.org). At this moment, Honeymoon provides these following APIs:


```swift
let app = Honeymoon()
```

### Basic Reponse

```swift
app.get("/") { req in
    return "Honeymoon started."
}
```

###  Paramaters in URL

```swift
app.get("/list/<userId>") { req in
    let userId = req.params!["userId"]!
    return "list\(userId)"
}
```


###  HTML Template

```swift
app.get("/testTemplate") { req in
    return app.renderTemplate("Test", data: ["name": "Chester","value": 10000, "taxed_value": 10000 - (10000 * 0.4), "in_ca": true])
}
```


### Form

```swift 
app.post("/post") { req in
    let c = req.form!["content"]!
    return "Content: \(c)"
}
```


### Redirect

```swift
app.get("/testRedirect") { req in
    return app.redirect("/target")
}
```

## Try it out

Currently there's a [bug](https://github.com/Carthage/Carthage/issues/808) in Xcode when trying to use Swift framework in OS X command line application. So the example code is now in the tests.

Clone the project , use `pod install` to install the dependencies. Open the generated `xcworkspace` file and use `Cmd + U` to run the test. Go to `localhost:8000` and that's it.


## License

The MIT License