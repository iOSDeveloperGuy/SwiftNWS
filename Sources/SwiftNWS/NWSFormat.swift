import Foundation

/// Supported response formats for the NWS API.
public enum NWSFormat: String {
    /// GeoJSON format (application/geo+json)
    case geoJSON = "application/geo+json"
    
    /// JSON-LD format (application/ld+json)
    case jsonLD = "application/ld+json"
    
    /// DWML format (application/vnd.noaa.dwml+xml)
    case dwml = "application/vnd.noaa.dwml+xml"
    
    /// OXML format (application/vnd.noaa.obs+xml)
    case oxml = "application/vnd.noaa.obs+xml"
    
    /// CAP format (application/cap+xml)
    case cap = "application/cap+xml"
    
    /// ATOM format (application/atom+xml)
    case atom = "application/atom+xml"
}
