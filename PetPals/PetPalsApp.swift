import SwiftUI

@main
struct PetPalsApp: App {
    @StateObject private var game = PetGame()
    var body: some Scene {
        WindowGroup { PetPalsRoot().environmentObject(game) }
    }
}

struct Pet: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var species: String
    var color: String
    var gender: String
    var level = 5
    var hp = 345
    var maxHP = 534
    var strength = 53
    var agility = 23
    var defense = 53
    var intelligence = 13
    var emoji: String {
        switch species {
        case "Kougra": return "🐯"
        case "Kau": return "🐮"
        case "Uni": return "🦄"
        case "Quiggle": return "🐸"
        case "Acara": return "🐰"
        case "Kacheek": return "🐭"
        case "Wocky": return "🐱"
        case "Scorchio": return "🐲"
        case "Gelert": return "🐶"
        case "Lupe": return "🐺"
        default: return "🐾"
        }
    }
}

func petArtName(_ pet: Pet) -> String {
    if pet.color == "Blue" && pet.species == "Kacheek" { return "BlueKacheekArt" }
    switch pet.species {
    case "Kougra": return "KougraArt"
    case "Kau": return "KauArt"
    case "Uni": return "UniArt"
    case "Quiggle": return "QuiggleArt"
    case "Acara": return "AcaraArt"
    case "Kacheek": return "KacheekArt"
    case "Wocky": return "WockyArt"
    case "Scorchio": return "ScorchioArt"
    case "Gelert": return "GelertArt"
    case "Eyrie": return "EyrieArt"
    case "Blumaroo": return "BlumarooArt"
    case "Skeith": return "SkeithArt"
    case "Ogrin": return "OgrinArt"
    case "Lupe": return "KyuArt"
    default: return "KougraArt"
    }
}

@MainActor
final class PetGame: ObservableObject {
    @Published var pets: [Pet] = [] { didSet { persist() } }
    @Published var selectedID: UUID? { didSet { UserDefaults.standard.set(selectedID?.uuidString, forKey: "petpals.selected") } }
    @Published var coins = 204_871
    @Published var neopoints = 1_460
    private let key = "petpals.roster"

    init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Pet].self, from: data), !decoded.isEmpty {
            pets = decoded
        } else {
            pets = [
                Pet(name: "Cooper", species: "Kacheek", color: "Blue", gender: "Male"),
                Pet(name: "Riley", species: "Kacheek", color: "Blue", gender: "Female"),
                Pet(name: "Tucker", species: "Kacheek", color: "Blue", gender: "Male"),
                Pet(name: "Bella", species: "Kacheek", color: "Blue", gender: "Female"),
                Pet(name: "Cookie", species: "Kacheek", color: "Blue", gender: "Female"),
                Pet(name: "Abby", species: "Kacheek", color: "Blue", gender: "Female")
            ]
        }
        if let s = UserDefaults.standard.string(forKey: "petpals.selected"),
           let id = UUID(uuidString: s), pets.contains(where: {$0.id == id}) {
            selectedID = id
        } else { selectedID = pets.first?.id }
    }
    var selected: Pet? { pets.first(where: {$0.id == selectedID}) ?? pets.first }
    func choose(_ pet: Pet) { selectedID = pet.id }
    func create(name: String, species: String, color: String, gender: String) {
        let pet = Pet(name: name, species: species, color: color, gender: gender)
        pets.insert(pet, at: 0); selectedID = pet.id
    }
    private func persist() {
        if let data = try? JSONEncoder().encode(pets) { UserDefaults.standard.set(data, forKey: key) }
    }
}

enum Screen: String, CaseIterable {
    case home = "Home", create = "Create", pets = "My Pets", profile = "Profile"
    var icon: String {
        switch self {
        case .home: "house.fill"
        case .create: "plus.square.fill"
        case .pets: "pawprint.fill"
        case .profile: "person.crop.circle.fill"
        }
    }
}

struct Palette {
    static let yellow = Color(red: 1.0, green: 0.78, blue: 0.10)
    static let paleYellow = Color(red: 1.0, green: 0.93, blue: 0.62)
    static let ink = Color(red: 0.10, green: 0.10, blue: 0.14)
    static let page = Color(red: 0.90, green: 0.90, blue: 0.89)
    static let paper = Color.white
    static let gold = Color(red: 0.76, green: 0.55, blue: 0.12)
}

struct PetPalsRoot: View {
    @EnvironmentObject private var game: PetGame
    @State private var screen: Screen = .home
    var body: some View {
        VStack(spacing: 0) {
            topBar
            Group {
                switch screen {
                case .home: DashboardView { screen = .create }
                case .create: CreatePetView { screen = .home }
                case .pets: RosterView()
                case .profile: ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            bottomBar
        }
        .background(Palette.page)
        .preferredColorScheme(.light)
    }
    private var topBar: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Text("✦").font(.system(size: 19, weight: .black))
                Text("PETPALS").font(.system(size: 22, weight: .black, design: .rounded))
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "circle.hexagongrid.fill")
                    Text("\(game.coins.formatted())")
                }
                .font(.system(size: 10, weight: .heavy, design: .rounded))
                .padding(.horizontal, 8).padding(.vertical, 6)
                .background(.white.opacity(0.86), in: Capsule())
                HStack(spacing: 4) {
                    Image(systemName: "leaf.fill")
                    Text("\(game.neopoints.formatted())")
                }
                .font(.system(size: 10, weight: .heavy, design: .rounded))
                .padding(.horizontal, 8).padding(.vertical, 6)
                .background(.white.opacity(0.86), in: Capsule())
            }
            .foregroundStyle(Palette.ink)
            .padding(.horizontal, 14).padding(.vertical, 11)
            Text("YOUR LITTLE WORLD  •  ADVENTURE AWAITS")
                .font(.system(size: 8, weight: .black, design: .rounded))
                .tracking(2).frame(maxWidth: .infinity).padding(.vertical, 4)
                .background(Palette.ink.opacity(0.08))
        }
        .background(Palette.yellow)
        .overlay(alignment: .bottom) { Rectangle().fill(Palette.gold.opacity(0.6)).frame(height: 2) }
    }
    private var bottomBar: some View {
        HStack(spacing: 0) {
            ForEach(Screen.allCases, id: \.self) { item in
                Button { screen = item } label: {
                    VStack(spacing: 4) {
                        Image(systemName: item.icon).font(.system(size: 18, weight: .bold))
                        Text(item.rawValue).font(.system(size: 10, weight: .heavy, design: .rounded))
                    }
                    .foregroundStyle(screen == item ? Palette.ink : .gray)
                    .frame(maxWidth: .infinity).padding(.vertical, 9)
                    .background(screen == item ? Palette.yellow.opacity(0.32) : .white)
                }.buttonStyle(.plain)
            }
        }
        .background(.white)
        .overlay(alignment: .top) { Rectangle().fill(.black.opacity(0.16)).frame(height: 1) }
    }
}

struct Panel<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content
    var body: some View {
        VStack(spacing: 0) {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .black, design: .rounded))
                .tracking(1)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12).padding(.vertical, 9)
                .background(Palette.ink)
            content
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.black.opacity(0.16), lineWidth: 1))
        .shadow(color: .black.opacity(0.06), radius: 2, y: 1)
    }
}

struct DashboardView: View {
    @EnvironmentObject private var game: PetGame
    let onCreate: () -> Void
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if let pet = game.selected {
                    Panel(title: "User Info  •  \(pet.name)") {
                        VStack(spacing: 12) {
                            HStack(alignment: .top, spacing: 14) {
                                VStack(spacing: 5) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10).fill(Color(red: 0.90, green: 0.96, blue: 1.0))
                                        Image(petArtName(pet)).resizable().scaledToFit().padding(6)
                                    }.frame(width: 116, height: 110)
                                    Text("\(pet.level) months").font(.system(size: 12, weight: .black, design: .rounded))
                                }
                                VStack(alignment: .leading, spacing: 8) {
                                    InfoLine(label: "Name", value: pet.name)
                                    InfoLine(label: "Gender", value: pet.gender)
                                    InfoLine(label: "Species", value: pet.species)
                                    InfoLine(label: "Color", value: pet.color)
                                    InfoLine(label: "Last spotted", value: "Just now")
                                    Spacer(minLength: 0)
                                }.padding(.top, 3)
                                Spacer(minLength: 0)
                            }
                            HStack(spacing: 0) {
                                QuickAction(icon: "flag.fill", title: "Trades")
                                QuickAction(icon: "hammer.fill", title: "Auctions")
                                QuickAction(icon: "scroll.fill", title: "Wishlist")
                                QuickAction(icon: "envelope.fill", title: "Neomail")
                                QuickAction(icon: "face.smiling.fill", title: "Neofriend")
                            }
                        }.padding(12)
                    }
                    Panel(title: "Pet stats") {
                        VStack(spacing: 9) {
                            HStack {
                                Text("HEALTH").font(.system(size: 10, weight: .black))
                                Spacer()
                                Text("\(pet.hp)/\(pet.maxHP) HP").font(.system(size: 10, weight: .black))
                            }
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(.gray.opacity(0.2))
                                    Capsule().fill(Color(red: 0.20, green: 0.59, blue: 0.34))
                                        .frame(width: geo.size.width * CGFloat(pet.hp) / CGFloat(pet.maxHP))
                                }
                            }.frame(height: 9)
                            HStack(spacing: 7) {
                                StatBadge(label: "STR", value: pet.strength, color: .red)
                                StatBadge(label: "AGI", value: pet.agility, color: .blue)
                                StatBadge(label: "DEF", value: pet.defense, color: .orange)
                                StatBadge(label: "INT", value: pet.intelligence, color: .green)
                            }
                        }.padding(12)
                    }
                }
                Panel(title: "Neopets") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                        ForEach(game.pets) { pet in
                            Button { game.choose(pet) } label: {
                                VStack(spacing: 4) {
                                    Image(petArtName(pet)).resizable().scaledToFit().frame(height: 46)
                                    Text(pet.name).font(.system(size: 11, weight: .bold, design: .rounded)).lineLimit(1)
                                }
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(game.selectedID == pet.id ? Palette.paleYellow.opacity(0.65) : .white)
                                .clipShape(RoundedRectangle(cornerRadius: 7))
                                .overlay(RoundedRectangle(cornerRadius: 7).stroke(.black.opacity(game.selectedID == pet.id ? 0.22 : 0.05)))
                            }.buttonStyle(.plain).foregroundStyle(Palette.ink)
                        }
                    }.padding(9)
                }
                Panel(title: "Collections") {
                    HStack(spacing: 0) {
                        CollectionItem(icon: "seal.fill", title: "Secret Avatars", count: "11")
                        CollectionItem(icon: "rosette", title: "Stamps", count: "0")
                        CollectionItem(icon: "star.fill", title: "Site Themes", count: "1")
                        CollectionItem(icon: "key.fill", title: "Quest Tokens", count: "1")
                    }.padding(.vertical, 12)
                }
                Button(action: onCreate) {
                    Label("CREATE A NEOPET", systemImage: "plus.circle.fill")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .frame(maxWidth: .infinity).padding(14)
                        .background(Palette.yellow, in: RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Palette.gold.opacity(0.5)))
                }.buttonStyle(.plain).foregroundStyle(Palette.ink)
            }.padding(12)
        }
    }
}

struct InfoLine: View {
    let label: String
    let value: String
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text(label + ":").font(.system(size: 11, weight: .bold))
            Text(value).font(.system(size: 11, weight: .medium))
                .lineLimit(1).minimumScaleFactor(0.75)
        }.foregroundStyle(Palette.ink)
    }
}

struct QuickAction: View {
    let icon: String
    let title: String
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 18, weight: .semibold)).foregroundStyle(Palette.gold)
            Text(title).font(.system(size: 8, weight: .bold)).lineLimit(1).minimumScaleFactor(0.7)
        }.frame(maxWidth: .infinity)
    }
}

struct StatBadge: View {
    let label: String
    let value: Int
    let color: Color
    var body: some View {
        VStack(spacing: 3) {
            Text(label).font(.system(size: 9, weight: .black))
            Text("\(value)").font(.system(size: 16, weight: .black, design: .rounded))
        }
        .foregroundStyle(Palette.ink)
        .frame(maxWidth: .infinity).padding(.vertical, 7)
        .background(color.opacity(0.18), in: RoundedRectangle(cornerRadius: 6))
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(color.opacity(0.65), lineWidth: 1))
    }
}

struct CollectionItem: View {
    let icon: String
    let title: String
    let count: String
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 22, weight: .bold)).foregroundStyle(Palette.gold)
                .frame(height: 28)
            Text(title).font(.system(size: 8, weight: .bold)).multilineTextAlignment(.center).lineLimit(2).frame(height: 22)
            Text(count).font(.system(size: 10, weight: .black))
        }.frame(maxWidth: .infinity)
    }
}

struct CreatePetView: View {
    @EnvironmentObject private var game: PetGame
    let onDone: () -> Void
    @State private var species = "Kougra"
    @State private var color = "Yellow"
    @State private var name = ""
    @State private var gender = "Male"
    @State private var showError = false
    private let speciesList = ["Kyu", "Kougra", "Eyrie", "Kau", "Scorchio", "Uni", "Quiggle", "Blumaroo", "Gelert", "Skeith", "Big Slorg", "Wocky", "Ogrin", "Acara", "Kacheek", "Lupe"]
    private let colors: [(String, Color)] = [("Red", .red), ("Blue", .blue), ("Green", .green), ("Yellow", .yellow)]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Panel(title: "Create-a-pet") {
                    VStack(spacing: 11) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 9).fill(Color(red: 0.09, green: 0.25, blue: 0.31))
                            ForEach(0..<16, id: \.self) { i in
                                Circle().fill(.white.opacity(0.06)).frame(width: CGFloat(8 + (i % 3) * 5))
                                    .offset(x: CGFloat((i * 37) % 260 - 130), y: CGFloat((i * 23) % 110 - 55))
                            }
                            VStack(spacing: 2) {
                                Image(createArtName(species)).resizable().scaledToFit().frame(width: 110, height: 110)
                                Text("\(color.uppercased()) \(species.uppercased())").font(.system(size: 11, weight: .black, design: .rounded)).foregroundStyle(.white)
                            }
                        }.frame(height: 190)
                        Text("SELECT SPECIES").font(.system(size: 10, weight: .black, design: .rounded)).frame(maxWidth: .infinity, alignment: .leading)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 7) {
                            ForEach(speciesList, id: \.self) { item in
                                Button { species = item } label: {
                                    VStack(spacing: 4) {
                                        Image(createArtName(item)).resizable().scaledToFit().frame(height: 42)
                                        Text(item.uppercased()).font(.system(size: 8, weight: .black, design: .rounded)).lineLimit(1).minimumScaleFactor(0.7)
                                    }.frame(maxWidth: .infinity).padding(.vertical, 8)
                                        .background(species == item ? Palette.yellow : .white)
                                        .clipShape(RoundedRectangle(cornerRadius: 7))
                                        .overlay(RoundedRectangle(cornerRadius: 7).stroke(.black.opacity(species == item ? 0.35 : 0.10)))
                                }.buttonStyle(.plain).foregroundStyle(Palette.ink)
                            }
                        }
                        Text("COLOR").font(.system(size: 10, weight: .black, design: .rounded)).frame(maxWidth: .infinity, alignment: .leading)
                        HStack(spacing: 5) {
                            ForEach(colors, id: \.0) { item in
                                Button { color = item.0 } label: {
                                    VStack(spacing: 4) {
                                        RoundedRectangle(cornerRadius: 3).fill(item.1).frame(height: 15)
                                            .overlay(RoundedRectangle(cornerRadius: 3).stroke(.black.opacity(0.2)))
                                        Text(item.0.uppercased()).font(.system(size: 8, weight: .black))
                                    }.padding(5).frame(maxWidth: .infinity)
                                        .background(color == item.0 ? Palette.paleYellow : .white, in: RoundedRectangle(cornerRadius: 6))
                                }.buttonStyle(.plain).foregroundStyle(Palette.ink)
                            }
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text("NEOPET NAME").font(.system(size: 10, weight: .black, design: .rounded))
                            TextField("Enter a name", text: $name)
                                .textInputAutocapitalization(.words)
                                .padding(11).background(.white, in: RoundedRectangle(cornerRadius: 5))
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black.opacity(0.2)))
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text("GENDER").font(.system(size: 10, weight: .black, design: .rounded))
                            Picker("Gender", selection: $gender) {
                                Text("Male").tag("Male")
                                Text("Female").tag("Female")
                            }.pickerStyle(.segmented)
                        }
                        if showError {
                            Text("Enter a name between 2 and 16 characters.")
                                .font(.system(size: 11, weight: .semibold)).foregroundStyle(.red)
                        }
                        Button {
                            let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard (2...16).contains(trimmed.count) else { showError = true; return }
                            game.create(name: trimmed, species: normalizedSpecies, color: color, gender: gender)
                            onDone()
                        } label: {
                            Text("CREATE MY PET")
                                .font(.system(size: 14, weight: .black, design: .rounded))
                                .frame(maxWidth: .infinity).padding(13)
                                .background(Palette.yellow, in: RoundedRectangle(cornerRadius: 7))
                        }.buttonStyle(.plain).foregroundStyle(Palette.ink)
                    }.padding(11).background(Color(red: 1.0, green: 0.95, blue: 0.75))
                }
            }.padding(12)
        }
    }
    private func createArtName(_ s: String) -> String {
        switch s {
        case "Kyu": return "KyuArt"
        case "Kougra": return "KougraArt"
        case "Eyrie": return "EyrieArt"
        case "Kau": return "KauArt"
        case "Scorchio": return "ScorchioArt"
        case "Uni": return "UniArt"
        case "Quiggle": return "QuiggleArt"
        case "Blumaroo": return "BlumarooArt"
        case "Gelert": return "GelertArt"
        case "Skeith": return "SkeithArt"
        case "Big Slorg": return "BigSlorgArt"
        case "Wocky": return "WockyArt"
        case "Ogrin": return "OgrinArt"
        case "Acara": return "AcaraArt"
        case "Kacheek": return "KacheekArt"
        default: return "KougraArt"
        }
    }
    private var normalizedSpecies: String { species == "Kyu" ? "Kougra" : species }
    private var speciesEmoji: String { emoji(for: species) }
    private func emoji(for s: String) -> String {
        switch s {
        case "Kyu", "Kougra": "🐯"
        case "Eyrie": "🦅"
        case "Kau": "🐮"
        case "Scorchio": "🐲"
        case "Uni": "🦄"
        case "Quiggle": "🐸"
        case "Blumaroo": "🦘"
        case "Gelert": "🐶"
        case "Skeith": "🦎"
        case "Big Slorg": "🐌"
        case "Wocky": "🐱"
        case "Ogrin": "🦊"
        case "Acara": "🐰"
        case "Kacheek": "🐭"
        case "Lupe": "🐺"
        default: "🐾"
        }
    }
}

struct RosterView: View {
    @EnvironmentObject private var game: PetGame
    var body: some View {
        ScrollView {
            Panel(title: "Your pets") {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(game.pets) { pet in
                        Button { game.choose(pet) } label: {
                            VStack(spacing: 6) {
                                Image(petArtName(pet)).resizable().scaledToFit().frame(height: 58)
                                Text(pet.name).font(.system(size: 13, weight: .black, design: .rounded))
                                Text("Lv \(pet.level) • \(pet.color) \(pet.species)").font(.system(size: 9, weight: .medium)).foregroundStyle(.secondary)
                            }.frame(maxWidth: .infinity).padding(12).background(game.selectedID == pet.id ? Palette.paleYellow : .white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(.black.opacity(0.12)))
                        }.buttonStyle(.plain).foregroundStyle(Palette.ink)
                    }
                }.padding(10)
            }.padding(12)
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject private var game: PetGame
    var body: some View {
        ScrollView {
            Panel(title: "Player profile") {
                VStack(spacing: 12) {
                    Text("⭐").font(.system(size: 58))
                    Text("PetPals Player").font(.system(size: 22, weight: .black, design: .rounded))
                    Text("Virtual pet collector").font(.system(size: 12, weight: .medium)).foregroundStyle(.secondary)
                    Divider()
                    HStack {
                        ProfileMetric(value: "\(game.pets.count)", label: "PETS")
                        ProfileMetric(value: game.coins.formatted(), label: "COINS")
                        ProfileMetric(value: "11", label: "AVATARS")
                    }
                    Text("Your progress is saved on this iPhone.")
                        .font(.system(size: 11, weight: .medium)).foregroundStyle(.secondary)
                }.padding(18).frame(maxWidth: .infinity).background(.white)
            }.padding(12)
        }
    }
}

struct ProfileMetric: View {
    let value: String
    let label: String
    var body: some View {
        VStack(spacing: 5) {
            Text(value).font(.system(size: 17, weight: .black, design: .rounded))
            Text(label).font(.system(size: 9, weight: .heavy)).foregroundStyle(.secondary)
        }.frame(maxWidth: .infinity)
    }
}
