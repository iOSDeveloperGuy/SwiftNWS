# SwiftNWS

A Swift wrapper for the National Weather Service (NWS) API that provides easy access to weather data including forecasts, alerts, and observations.

## Features

- Swift-idiomatic API design with async/await support
- Comprehensive coverage of NWS API endpoints
- Type-safe models for all API responses
- Robust error handling
- **NO** dependencies
- Detailed documentation and examples

## Requirements

- iOS 15.0+ / macOS 12.0+ / tvOS 15.0+ / watchOS 8.0+
- Swift 5.5+
- Xcode 13.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/iOSDeveloperGuy/SwiftNWS.git", from: "1.0.0")
]
```

Or add it directly in Xcode using File > Swift Packages > Add Package Dependency.

## Usage

### Initialization

```swift
import SwiftNWS

// Initialize with default configuration
let nwsClient = NWSClient()

// Or with custom configuration
let config = NWSConfiguration(
    baseURL: URL(string: "https://api.weather.gov")!,
    userAgent: "MyWeatherApp/1.0 (myapp.com, contact@myapp.com)",
    defaultFormat: .geoJSON,
    timeoutInterval: 30.0
)
let nwsClient = NWSClient(configuration: config)
```

### Getting Weather Forecasts

```swift
// Get forecast for a specific location by coordinates
do {
    let forecast = try await nwsClient.forecasts.getForecastForPoint(
        latitude: 39.7456,
        longitude: -97.0892
    )

    // Access forecast data
    for period in forecast.properties.periods {
        print("\(period.name): \(period.detailedForecast)")
    }
} catch {
    print("Error fetching forecast: \(error)")
}

// Get hourly forecast
do {
    let hourlyForecast = try await nwsClient.forecasts.getHourlyForecastForPoint(
        latitude: 39.7456,
        longitude: -97.0892
    )

    // Access hourly forecast data
    for period in hourlyForecast.properties.periods {
        print("\(period.startTime) - \(period.temperature)°\(period.temperatureUnit)")
    }
} catch {
    print("Error fetching hourly forecast: \(error)")
}
```

### Getting Weather Alerts

```swift
// Get all active alerts
do {
    let activeAlerts = try await nwsClient.alerts.getActiveAlerts()

    for alert in activeAlerts.features {
        print("Alert: \(alert.event) - \(alert.headline ?? "No headline")")
        print("Severity: \(alert.severity.rawValue)")
        print("Areas: \(alert.areaDesc)")
    }
} catch {
    print("Error fetching alerts: \(error)")
}

// Get alerts for a specific area
do {
    let areaAlerts = try await nwsClient.alerts.getActiveAlertsForArea("CA")
    print("Found \(areaAlerts.features.count) active alerts in California")
} catch {
    print("Error fetching area alerts: \(error)")
}
```

### Getting Weather Observations

```swift
// Get latest observations for a station
do {
    let observations = try await nwsClient.observations.getLatestObservations(stationId: "KNYC")

    if let temp = observations.properties.temperature?.value {
        print("Current temperature: \(temp)°C")
    }

    if let description = observations.properties.textDescription {
        print("Conditions: \(description)")
    }
} catch {
    print("Error fetching observations: \(error)")
}

// Get observations for a time period
do {
    let startDate = Date().addingTimeInterval(-86400) // 24 hours ago
    let endDate = Date()

    let observations = try await nwsClient.observations.getObservations(
        stationId: "KNYC",
        start: startDate,
        end: endDate
    )

    print("Retrieved \(observations.features.count) observations")
} catch {
    print("Error fetching observations: \(error)")
}
```

### Finding Weather Stations

```swift
// Get stations near a point
do {
    let stations = try await nwsClient.stations.getStationsForPoint(
        latitude: 39.7456,
        longitude: -97.0892
    )

    for station in stations.features {
        print("Station: \(station.properties.name) (\(station.properties.stationIdentifier))")
    }
} catch {
    print("Error fetching stations: \(error)")
}

// Get specific station
do {
    let station = try await nwsClient.stations.getStation(stationId: "KNYC")
    print("Station: \(station.properties.name)")
    print("Time Zone: \(station.properties.timeZone ?? "Unknown")")
} catch {
    print("Error fetching station: \(error)")
}
```

### Working with Zones

```swift
// Get all forecast zones
do {
    let zones = try await nwsClient.zones.getZones(type: .forecast)
    print("Retrieved \(zones.features.count) forecast zones")
} catch {
    print("Error fetching zones: \(error)")
}

// Get specific zone
do {
    let zone = try await nwsClient.zones.getZone(type: .forecast, zoneId: "NYZ072")
    print("Zone: \(zone.properties.name)")
} catch {
    print("Error fetching zone: \(error)")
}

// Get forecast for a zone
do {
    let forecast = try await nwsClient.zones.getForecastForZone(type: .forecast, zoneId: "NYZ072")

    for period in forecast.properties.periods {
        print("\(period.name): \(period.detailedForecast)")
    }
} catch {
    print("Error fetching zone forecast: \(error)")
}
```

### Working with Offices

```swift
// Get all offices
do {
    let offices = try await nwsClient.offices.getAllOffices()
    print("Retrieved \(offices.features.count) offices")
} catch {
    print("Error fetching offices: \(error)")
}

// Get specific office
do {
    let office = try await nwsClient.offices.getOffice(officeId: "OKX")
    print("Office: \(office.properties.name)")
} catch {
    print("Error fetching office: \(error)")
}

// Get headlines for an office
do {
    let headlines = try await nwsClient.offices.getHeadlinesForOffice(officeId: "OKX")

    for headline in headlines.features {
        print("Headline: \(headline.properties.title)")
    }
} catch {
    print("Error fetching headlines: \(error)")
}
```

## Error Handling

The wrapper uses Swift's built-in error handling mechanisms. All service methods are marked with `throws` and will throw appropriate `NWSError` instances when errors occur.

```swift
do {
    let forecast = try await nwsClient.forecasts.getForecastForPoint(
        latitude: 39.7456,
        longitude: -97.0892
    )
    // Process forecast
} catch let error as NWSError {
    switch error {
    case .rateLimitExceeded:
        print("Rate limit exceeded. Please try again later.")
    case .networkError(let underlyingError):
        print("Network error: \(underlyingError.localizedDescription)")
    case .serverError(let statusCode, let message):
        print("Server error (\(statusCode)): \(message ?? "No message")")
    case .notFound:
        print("Resource not found")
    default:
        print("Error: \(error.localizedDescription)")
    }
} catch {
    print("Unexpected error: \(error)")
}
```

## Advanced Usage

### Custom Response Formats

```swift
// Configure client to use a different default format
let config = NWSConfiguration(defaultFormat: .jsonLD)
let nwsClient = NWSClient(configuration: config)
```

### Setting User Agent

The NWS API requires a User-Agent header to identify your application. It's recommended to include contact information.

```swift
nwsClient.setUserAgent("MyWeatherApp/1.0 (myapp.com, contact@myapp.com)")
```

## Best Practices

1. **Set a descriptive User-Agent**: Include your app name, version, and contact information.
2. **Handle rate limits**: The NWS API has rate limits. If you receive a `.rateLimitExceeded` error, wait before retrying.
3. **Cache responses**: Weather data doesn't change frequently. Consider caching responses to reduce API calls.
4. **Handle errors gracefully**: Provide meaningful feedback to users when API calls fail.
5. **Use appropriate endpoints**: Use the most specific endpoint for your needs to minimize data transfer.

## License

This project is available under the MIT license. See the LICENSE file for more info.

## Acknowledgements

This wrapper is not affiliated with or endorsed by the National Weather Service or NOAA.

## Contact

For questions, issues, or feature requests, please [open an issue](https://github.com/iOSDeveloperGuy/SwiftNWS/issues/new) on the GitHub repository.
