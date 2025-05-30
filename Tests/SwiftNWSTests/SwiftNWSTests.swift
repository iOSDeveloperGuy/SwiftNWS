import Testing
@testable import SwiftNWS

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
}

/// Example application demonstrating the usage of the NWSWrapper.
/// This file contains test code to validate the functionality of the wrapper.

// MARK: - Test Functions

/// Tests the forecast functionality of the wrapper.
@Test func testForecast() async throws {
    print("Testing forecast functionality...")
    
    var config = NWSConfiguration()
    config.userAgent = "SwiftNWSExample/1.0"
    let client = NWSClient(configuration: config)

    // Test getting forecast for a point
    let forecast = try await client.forecasts.getForecastForPoint(
        latitude: 39.7456,
        longitude: -97.0892
    )
    
    print("✅ Successfully retrieved forecast")
    print("Updated: \(forecast.properties.updated)")
    
    if let firstPeriod = forecast.properties.periods.first {
        print("First period: \(firstPeriod.name)")
        print("Temperature: \(firstPeriod.temperature)°\(firstPeriod.temperatureUnit)")
        print("Forecast: \(firstPeriod.detailedForecast)")
    }
    
    // Test getting hourly forecast for a point
    let hourlyForecast = try await client.forecasts.getHourlyForecastForPoint(
        latitude: 39.7456,
        longitude: -97.0892
    )
    
    print("✅ Successfully retrieved hourly forecast")
    print("Retrieved \(hourlyForecast.properties.periods.count) hourly periods")
}

/// Tests the alerts functionality of the wrapper.
func testAlerts(client: NWSClient) async {
    print("\nTesting alerts functionality...")
    
    do {
        // Test getting active alerts
        let activeAlerts = try await client.alerts.getActiveAlerts()
        
        print("✅ Successfully retrieved active alerts")
        print("Found \(activeAlerts.features.count) active alerts")
        
        if let firstAlert = activeAlerts.features.first {
            print("First alert: \(firstAlert.event)")
            print("Severity: \(firstAlert.severity.rawValue)")
            print("Area: \(firstAlert.areaDesc)")
        }
        
        // Test getting alert count
        let alertCount = try await client.alerts.getActiveAlertCount()
        
        print("✅ Successfully retrieved alert count")
        print("Total alerts: \(alertCount.total)")
        print("Land alerts: \(alertCount.land)")
        print("Marine alerts: \(alertCount.marine)")
        
    } catch {
        print("❌ Error testing alerts: \(error)")
    }
}

/// Tests the observations functionality of the wrapper.
func testObservations(client: NWSClient) async {
    print("\nTesting observations functionality...")
    
    do {
        // Test getting stations first to find a valid station ID
        let stations = try await client.stations.getStationsForPoint(
            latitude: 39.7456,
            longitude: -97.0892
        )
        
        guard let stationId = stations.features.first?.properties.stationIdentifier else {
            print("❌ No stations found for test point")
            return
        }
        
        print("Using station ID: \(stationId)")
        
        // Test getting latest observations for a station
        let observations = try await client.observations.getLatestObservations(stationId: stationId)
        
        print("✅ Successfully retrieved observations")
        print("Timestamp: \(observations.properties.timestamp)")
        
        if let temp = observations.properties.temperature?.value {
            print("Temperature: \(temp)")
        }
        
        if let description = observations.properties.textDescription {
            print("Description: \(description)")
        }
        
    } catch {
        print("❌ Error testing observations: \(error)")
    }
}

/// Tests the stations functionality of the wrapper.
func testStations(client: NWSClient) async {
    print("\nTesting stations functionality...")
    
    do {
        // Test getting stations for a point
        let stations = try await client.stations.getStationsForPoint(
            latitude: 39.7456,
            longitude: -97.0892
        )
        
        print("✅ Successfully retrieved stations")
        print("Found \(stations.features.count) stations")
        
        if let firstStation = stations.features.first {
            print("First station: \(firstStation.properties.name) (\(firstStation.properties.stationIdentifier))")
            
            // Test getting a specific station
            let station = try await client.stations.getStation(stationId: firstStation.properties.stationIdentifier)
            
            print("✅ Successfully retrieved specific station")
            print("Station name: \(station.properties.name)")
        }
        
    } catch {
        print("❌ Error testing stations: \(error)")
    }
}

/// Tests the zones functionality of the wrapper.
func testZones(client: NWSClient) async {
    print("\nTesting zones functionality...")
    
    do {
        // Test getting zones
        let zones = try await client.zones.getZones(type: .forecast)
        
        print("✅ Successfully retrieved zones")
        print("Found \(zones.features.count) zones")
        
        if let firstZone = zones.features.first {
            print("First zone: \(firstZone.properties.name) (\(firstZone.properties.id))")
            
            // Test getting a specific zone
            let zone = try await client.zones.getZone(type: .forecast, zoneId: firstZone.properties.id)
            
            print("✅ Successfully retrieved specific zone")
            print("Zone name: \(zone.properties.name)")
            
            // Test getting forecast for a zone
            do {
                let forecast = try await client.zones.getForecastForZone(type: .forecast, zoneId: firstZone.properties.id)
                
                print("✅ Successfully retrieved zone forecast")
                print("Periods: \(forecast.properties.periods.count)")
            } catch {
                print("Note: Zone forecast not available for this zone")
            }
        }
        
    } catch {
        print("❌ Error testing zones: \(error)")
    }
}

/// Tests the offices functionality of the wrapper.
func testOffices(client: NWSClient) async {
    print("\nTesting offices functionality...")
    
    do {
        // Test getting offices
        let offices = try await client.offices.getAllOffices()
        
        print("✅ Successfully retrieved offices")
        print("Found \(offices.features.count) offices")
        
        if let firstOffice = offices.features.first {
            print("First office: \(firstOffice.properties.name) (\(firstOffice.properties.id))")
            
            // Test getting a specific office
            let office = try await client.offices.getOffice(officeId: firstOffice.properties.id)
            
            print("✅ Successfully retrieved specific office")
            print("Office name: \(office.properties.name)")
            
            // Test getting headlines for an office
            do {
                let headlines = try await client.offices.getHeadlinesForOffice(officeId: firstOffice.properties.id)
                
                print("✅ Successfully retrieved office headlines")
                print("Headlines: \(headlines.features.count)")
            } catch {
                print("Note: Headlines not available for this office")
            }
        }
        
    } catch {
        print("❌ Error testing offices: \(error)")
    }
}

/// Tests the points functionality of the wrapper.
func testPoints(client: NWSClient) async {
    print("\nTesting points functionality...")
    
    do {
        // Test getting a point
        let point = try await client.points.getPoint(
            latitude: 39.7456,
            longitude: -97.0892
        )
        
        print("✅ Successfully retrieved point")
        print("Grid ID: \(point.properties.gridId)")
        print("Grid X: \(point.properties.gridX)")
        print("Grid Y: \(point.properties.gridY)")
        print("Time Zone: \(point.properties.timeZone)")
        
    } catch {
        print("❌ Error testing points: \(error)")
    }
}
