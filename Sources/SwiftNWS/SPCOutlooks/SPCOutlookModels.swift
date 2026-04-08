import Foundation

/// Feature layers exposed by NOAA's SPC outlook geometry service.
public enum NWSSPCOutlookLayer: Int, CaseIterable, Codable, Sendable {
    case day1Categorical = 1
    case day1SignificantTornado = 2
    case day1ProbabilisticTornado = 3
    case day1SignificantHail = 4
    case day1ProbabilisticHail = 5
    case day1SignificantWind = 6
    case day1ProbabilisticWind = 7
    case day2Categorical = 9
    case day2SignificantTornado = 10
    case day2ProbabilisticTornado = 11
    case day2SignificantHail = 12
    case day2ProbabilisticHail = 13
    case day2SignificantWind = 14
    case day2ProbabilisticWind = 15
    case day3Categorical = 17
    case day3SignificantSevere = 18
    case day3Probabilistic = 19
    case day4Probabilistic = 21
    case day5Probabilistic = 22
    case day6Probabilistic = 23
    case day7Probabilistic = 24
    case day8Probabilistic = 25

    /// A stable human-readable layer name from the NOAA service.
    public var displayName: String {
        switch self {
        case .day1Categorical:
            return "Day 1 Categorical Outlook"
        case .day1SignificantTornado:
            return "Day 1 Significant Tornado Outlook"
        case .day1ProbabilisticTornado:
            return "Day 1 Probabilistic Tornado Outlook"
        case .day1SignificantHail:
            return "Day 1 Significant Hail Outlook"
        case .day1ProbabilisticHail:
            return "Day 1 Probabilistic Hail Outlook"
        case .day1SignificantWind:
            return "Day 1 Significant Wind Outlook"
        case .day1ProbabilisticWind:
            return "Day 1 Probabilistic Wind Outlook"
        case .day2Categorical:
            return "Day 2 Categorical Outlook"
        case .day2SignificantTornado:
            return "Day 2 Significant Tornado Outlook"
        case .day2ProbabilisticTornado:
            return "Day 2 Probabilistic Tornado Outlook"
        case .day2SignificantHail:
            return "Day 2 Significant Hail Outlook"
        case .day2ProbabilisticHail:
            return "Day 2 Probabilistic Hail Outlook"
        case .day2SignificantWind:
            return "Day 2 Significant Wind Outlook"
        case .day2ProbabilisticWind:
            return "Day 2 Probabilistic Wind Outlook"
        case .day3Categorical:
            return "Day 3 Categorical Outlook"
        case .day3SignificantSevere:
            return "Day 3 Significant Severe Outlook"
        case .day3Probabilistic:
            return "Day 3 Probabilistic Outlook"
        case .day4Probabilistic:
            return "Day 4 Probabilistic Outlook"
        case .day5Probabilistic:
            return "Day 5 Probabilistic Outlook"
        case .day6Probabilistic:
            return "Day 6 Probabilistic Outlook"
        case .day7Probabilistic:
            return "Day 7 Probabilistic Outlook"
        case .day8Probabilistic:
            return "Day 8 Probabilistic Outlook"
        }
    }
}

/// A GeoJSON feature collection returned by the SPC outlook geometry service.
public struct NWSSPCOutlookFeatureCollection: Decodable, Sendable {
    public let type: String
    public let features: [NWSSPCOutlookFeature]
}

/// A single SPC outlook feature with geometry ready for map rendering.
public struct NWSSPCOutlookFeature: Decodable, Identifiable, Sendable {
    public let id: String
    public let geometry: NWSGeoJSONGeometry
    public let properties: NWSSPCOutlookGeometryProperties

    private enum CodingKeys: String, CodingKey {
        case id
        case geometry
        case properties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let properties = try container.decode(NWSSPCOutlookGeometryProperties.self, forKey: .properties)

        self.geometry = try container.decode(NWSGeoJSONGeometry.self, forKey: .geometry)
        self.properties = properties

        if let id = try container.decodeLossyStringIfPresent(forKey: .id) {
            self.id = id
        } else if let objectID = properties.objectID {
            self.id = String(objectID)
        } else {
            self.id = UUID().uuidString
        }
    }
}

/// Properties attached to an SPC outlook geometry feature.
public struct NWSSPCOutlookGeometryProperties: Decodable, Sendable {
    public let objectID: Int?
    public let outlookValue: Int?
    public let valid: String?
    public let expire: String?
    public let issue: String?
    public let label: String?
    public let label2: String?
    public let stroke: String?
    public let fill: String?
    public let source: String?
    public let fileDate: Date?
    public let ingestDate: Date?
    public let area: Double?
    public let perimeter: Double?

    private enum CodingKeys: String, CodingKey {
        case objectID = "objectid"
        case outlookValue = "dn"
        case valid
        case expire
        case issue
        case label
        case label2
        case stroke
        case fill
        case source = "idp_source"
        case fileDate = "idp_filedate"
        case ingestDate = "idp_ingestdate"
        case area = "st_area(shape)"
        case perimeter = "st_perimeter(shape)"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.objectID = try container.decodeIfPresent(Int.self, forKey: .objectID)
        self.outlookValue = try container.decodeIfPresent(Int.self, forKey: .outlookValue)
        self.valid = try container.decodeIfPresent(String.self, forKey: .valid)
        self.expire = try container.decodeIfPresent(String.self, forKey: .expire)
        self.issue = try container.decodeIfPresent(String.self, forKey: .issue)
        self.label = try container.decodeIfPresent(String.self, forKey: .label)
        self.label2 = try container.decodeIfPresent(String.self, forKey: .label2)
        self.stroke = try container.decodeIfPresent(String.self, forKey: .stroke)
        self.fill = try container.decodeIfPresent(String.self, forKey: .fill)
        self.source = try container.decodeIfPresent(String.self, forKey: .source)
        self.fileDate = try container.decodeFlexibleDateIfPresent(forKey: .fileDate)
        self.ingestDate = try container.decodeFlexibleDateIfPresent(forKey: .ingestDate)
        self.area = try container.decodeIfPresent(Double.self, forKey: .area)
        self.perimeter = try container.decodeIfPresent(Double.self, forKey: .perimeter)
    }
}

/// GeoJSON polygon and multipolygon support used by SPC outlooks.
public enum NWSGeoJSONGeometry: Decodable, Sendable {
    case polygon([NWSGeoJSONRing])
    case multiPolygon([[NWSGeoJSONRing]])

    public var polygons: [[NWSGeoJSONRing]] {
        switch self {
        case .polygon(let rings):
            return [rings]
        case .multiPolygon(let polygons):
            return polygons
        }
    }

    /// Geometry coordinates normalized to latitude/longitude pairs for map overlays.
    public var coordinatePolygons: [[[NWSCoordinate]]] {
        polygons.map { polygon in
            polygon.map(\.coordinates)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case coordinates
    }

    private enum GeometryType: String, Decodable {
        case polygon = "Polygon"
        case multiPolygon = "MultiPolygon"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(GeometryType.self, forKey: .type)

        switch type {
        case .polygon:
            let coordinates = try container.decode([[[Double]]].self, forKey: .coordinates)
            self = .polygon(coordinates.map(NWSGeoJSONRing.init(coordinates:)))
        case .multiPolygon:
            let coordinates = try container.decode([[[[Double]]]].self, forKey: .coordinates)
            self = .multiPolygon(coordinates.map { $0.map(NWSGeoJSONRing.init(coordinates:)) })
        }
    }
}

/// A linear ring in a GeoJSON polygon.
public struct NWSGeoJSONRing: Sendable {
    public let coordinates: [NWSCoordinate]

    init(coordinates: [[Double]]) {
        self.coordinates = coordinates.compactMap { coordinate in
            guard coordinate.count >= 2 else { return nil }
            return NWSCoordinate(latitude: coordinate[1], longitude: coordinate[0])
        }
    }
}

private extension KeyedDecodingContainer {
    func decodeFlexibleDateIfPresent(forKey key: Key) throws -> Date? {
        if let milliseconds = try? decodeIfPresent(Double.self, forKey: key) {
            return Date(timeIntervalSince1970: milliseconds / 1000)
        }

        if let milliseconds = try? decodeIfPresent(Int.self, forKey: key) {
            return Date(timeIntervalSince1970: Double(milliseconds) / 1000)
        }

        if let string = try? decodeIfPresent(String.self, forKey: key) {
            return Date.fromISO8601(string)
        }

        return nil
    }

    func decodeLossyStringIfPresent(forKey key: Key) throws -> String? {
        if let string = try? decodeIfPresent(String.self, forKey: key) {
            return string
        }

        if let int = try? decodeIfPresent(Int.self, forKey: key) {
            return String(int)
        }

        if let double = try? decodeIfPresent(Double.self, forKey: key) {
            return String(double)
        }

        return nil
    }
}
