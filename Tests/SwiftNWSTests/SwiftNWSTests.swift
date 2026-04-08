import Foundation
import Testing
@testable import SwiftNWS

let latitude: Double = 29.236759
let longitude: Double = -81.462822

func client() -> NWSClient {
    let client = NWSClient(configuration: .default)
    
    // Set a custom user agent
    client.setUserAgent("SwiftNWS/1.0 (support@thomasswebsites.com)")
    
    return client
}


/// Tests the forecast functionality of the wrapper.
@Test func testForecast() async throws {
    print("Testing forecast functionality...")
    
   let client = client()

    // Test getting forecast for a point
    let forecast = try await client.forecasts.getForecastForPoint(
        latitude: latitude,
        longitude: longitude
    )
    
    print("✅ Successfully retrieved forecast")
    print("Updated: \(String(describing: forecast.properties.updateTime))")
    
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
@Test func testAlerts() async throws {
    print("\nTesting alerts functionality...")
    
    let client = client()
    
    // Test getting active alerts
    let activeAlerts = try await client.alerts.getActiveAlerts()
    
    print("✅ Successfully retrieved active alerts")
    print("Found \(activeAlerts.alerts.count) active alerts")
    
    if let firstAlert = activeAlerts.alerts.first?.alert {
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
}

/// Tests the observations functionality of the wrapper.
@Test func testObservations() async throws {
    print("\nTesting observations functionality...")
    
    let client = client()

    // Test getting stations first to find a valid station ID
    let stations = try await client.stations.getStationsForPoint(
        latitude: latitude,
        longitude: longitude
    )
    
    guard let stationId = stations.features.first?.properties.stationIdentifier else {
        print("❌ No stations found for test point")
        return
    }
    
    print("Using station ID: \(stationId)")
    
    // Test getting latest observations for a station
    let observations = try await client.observations.getLatestObservations(stationId: stationId)
        
    print("✅ Successfully retrieved observations")
    print("Timestamp: \(observations.features.first?.properties.timestamp.timeIntervalSinceNow ?? 0)")

    if let temp = observations.features.first?.properties.temperature {
        print("Temperature: \(temp)")
    }
    
    if let description = observations.features.first?.properties.textDescription {
        print("Description: \(description)")
    }
}

/// Tests the stations functionality of the wrapper.
@Test func testStations() async throws {
    print("\nTesting stations functionality...")
    
    let client = client()
    
    // Test getting stations for a point
    let stations = try await client.stations.getStationsForPoint(
        latitude: latitude,
        longitude: longitude
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
}

/// Tests the zones functionality of the wrapper.
@Test func testZones() async throws {
    print("\nTesting zones functionality...")
    
    let client = client()
    
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
}

/// Tests the offices functionality of the wrapper.
@Test func testOffices() async throws {
    print("\nTesting offices functionality...")
    
    let client = client()
    
    // Test getting offices
    let office = try await client.offices.getOffice(officeId: "JAX")
    
    print("✅ Successfully retrieved offices")
    print("Found \(office.address.debugDescription) offices")
    
    print("First office: \(office.name) (\(office.id))")
    
    // Test getting headlines for an office

    let headlines = try await client.offices.getHeadlinesForOffice(officeId: office.id)
    
    print("✅ Successfully retrieved office headlines")
    print("Headlines: \(headlines.headlines.count)")
}

/// Tests the points functionality of the wrapper.
@Test func testPoints() async throws {
    print("\nTesting points functionality...")
    
    let client = client()
    
    // Test getting a point
    let point = try await client.points.getPoint(
        latitude: latitude,
        longitude: longitude
    )
    
    print("✅ Successfully retrieved point")
    print("Grid ID: \(point.properties.gridId)")
    print("Grid X: \(point.properties.gridX)")
    print("Grid Y: \(point.properties.gridY)")
    print("Time Zone: \(point.properties.timeZone)")
}

/// Tests the text products functionality of the wrapper.
@Test func testProducts() async throws {
    print("\nTesting text products functionality...")

    let client = client()

    let productTypes = try await client.products.getProductTypes()

    print("✅ Successfully retrieved product types")
    print("Found \(productTypes.productTypes.count) product types")

    let spcOutlook = try await client.products.getLatestSPCOutlook(.day1)

    print("✅ Successfully retrieved latest SPC outlook")
    print("Product code: \(spcOutlook.productCode)")
    print("Issuing office: \(spcOutlook.issuingOffice)")
    print("Issued: \(spcOutlook.issuanceTime)")

    #expect(spcOutlook.productCode == "SWO")
    #expect((spcOutlook.productText?.isEmpty ?? true) == false)
}

@Test func testSPCOutlook() async throws {
    let outlook = try await client().products.getLatestSPCOutlook(.day1)
    print(outlook)
}

@Test func testSPCOutlookGeometryDecoding() throws {
    let json = """
    {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 101,
          "geometry": {
            "type": "MultiPolygon",
            "coordinates": [
              [
                [
                  [-97.0, 35.0],
                  [-96.0, 35.0],
                  [-96.0, 36.0],
                  [-97.0, 35.0]
                ]
              ]
            ]
          },
          "properties": {
            "objectid": 101,
            "dn": 3,
            "valid": "2026-04-08T12:00:00Z",
            "expire": "2026-04-09T12:00:00Z",
            "issue": "2026-04-08T11:30:00Z",
            "label": "Marginal",
            "stroke": "#000000",
            "fill": "#73B273",
            "idp_source": "SPC",
            "idp_filedate": 1712575800000,
            "idp_ingestdate": 1712575860000,
            "st_area(shape)": 12.5,
            "st_perimeter(shape)": 8.25
          }
        }
      ]
    }
    """

    let decoder = JSONDecoder()
    let collection = try decoder.decode(NWSSPCOutlookFeatureCollection.self, from: Data(json.utf8))

    #expect(collection.features.count == 1)
    #expect(collection.features[0].id == "101")
    #expect(collection.features[0].properties.outlookValue == 3)
    #expect(collection.features[0].geometry.coordinatePolygons[0][0].count == 4)
    #expect(collection.features[0].geometry.coordinatePolygons[0][0][0] == NWSCoordinate(latitude: 35.0, longitude: -97.0))
    #expect(collection.features[0].properties.fileDate != nil)
}

@Test func testSPCOutlookPolygonGeometryDecoding() throws {
    let json = """
    {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "geometry": {
            "type": "Polygon",
            "coordinates": [
              [
                [-99.0, 34.0],
                [-98.0, 34.0],
                [-98.0, 35.0],
                [-99.0, 34.0]
              ]
            ]
          },
          "properties": {
            "objectid": 55,
            "label": "Slight",
            "idp_filedate": "2026-04-08T12:00:00Z"
          }
        }
      ]
    }
    """

    let collection = try JSONDecoder().decode(NWSSPCOutlookFeatureCollection.self, from: Data(json.utf8))
    let feature = try #require(collection.features.first)

    #expect(feature.id == "55")
    #expect(feature.properties.label == "Slight")
    #expect(feature.properties.fileDate != nil)
    #expect(feature.geometry.coordinatePolygons.count == 1)
    #expect(feature.geometry.coordinatePolygons[0].count == 1)
    #expect(feature.geometry.coordinatePolygons[0][0][1] == NWSCoordinate(latitude: 34.0, longitude: -98.0))
}

@Test func testSPCOutlookFeatureStringIdentifierDecoding() throws {
    let json = """
    {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": "custom-id",
          "geometry": {
            "type": "Polygon",
            "coordinates": [
              [
                [-90.0, 30.0],
                [-89.5, 30.0],
                [-89.5, 30.5],
                [-90.0, 30.0]
              ]
            ]
          },
          "properties": {}
        }
      ]
    }
    """

    let collection = try JSONDecoder().decode(NWSSPCOutlookFeatureCollection.self, from: Data(json.utf8))
    #expect(collection.features.first?.id == "custom-id")
}

@Test func testAlertResponseDecodingVariants() throws {
    let allClearJSON = #""AllClear""#
    let hyphenatedJSON = #""all-clear""#
    let noneJSON = #""None""#

    #expect(try JSONDecoder().decode(NWSAlertResponse.self, from: Data(allClearJSON.utf8)) == .allClear)
    #expect(try JSONDecoder().decode(NWSAlertResponse.self, from: Data(hyphenatedJSON.utf8)) == .allClear)
    #expect(try JSONDecoder().decode(NWSAlertResponse.self, from: Data(noneJSON.utf8)) == .None)
}

@Test func testAlertResponseInvalidValueFails() throws {
    let invalidJSON = #""NotARealResponse""#
    #expect(throws: DecodingError.self) {
        try JSONDecoder().decode(NWSAlertResponse.self, from: Data(invalidJSON.utf8))
    }
}

@Test func testSPCOutlookGeometryLive() async throws {
    let outlook = try await client().spcOutlooks.getOutlookGeometry(for: .day1Categorical)

    #expect(outlook.type == "FeatureCollection")
    #expect(outlook.features.isEmpty == false)

    let firstFeature = try #require(outlook.features.first)
    #expect(firstFeature.geometry.coordinatePolygons.isEmpty == false)
    #expect(firstFeature.geometry.coordinatePolygons[0].isEmpty == false)
    #expect(firstFeature.geometry.coordinatePolygons[0][0].isEmpty == false)
}
