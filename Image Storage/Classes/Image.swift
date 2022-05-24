import Foundation

class Image: Codable {
    var name: String
    var description: String
    var isFavorite: Bool
    
    init(name: String, description: String, isFavorite: Bool) {
        self.name = name
        self.description = description
        self.isFavorite = isFavorite
    }
    
    private enum CodingKeys: String, CodingKey {
        case name,
             description,
             isFavorite
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.isFavorite, forKey: .isFavorite)
    }
    
    required public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }
    
    
}
