import SwiftUI

struct ContentView: View {
    @State private var showMenu = false
    @State private var selectedCity = "General"
    @State private var selectedMenuItem = "Arriving in Nepal"
    @State private var selectedTab: Tab = .home // Track the selected tab
    
    @AppStorage("AccentColor") private var accentColorHex: String = "#FF0000" // Default color as a hex string
    @AppStorage("selectedTheme") private var preferredColorScheme: String = "System" // Default preference
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Main Content View
            VStack(spacing: 0) {
                // Switch views based on the selected tab
                switch selectedTab {
                case .home:
                    HomeView(showMenu: $showMenu, selectedCity: $selectedCity, selectedMenuItem: $selectedMenuItem)
                case .profile:
                    ProfileView()
                case .settings:
                    SettingsView()
                }
                
                // Custom Tab Bar
                CustomTabBar(selectedTab: $selectedTab, accentColor: Color(hex: accentColorHex))
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    
            }
            
            // Side Menu
            if showMenu {
                MenuView(showMenu: $showMenu, selectedMenuItem: $selectedMenuItem)
                    .background(Color.white)
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut(duration: 0.2), value: showMenu)
                    .zIndex(1)
            }
        }
        .preferredColorScheme(getColorScheme())
    }
    
    // Function to determine the color scheme based on user preferences
    private func getColorScheme() -> ColorScheme? {
        switch preferredColorScheme {
        case "Light": return .light
        case "Dark": return .dark
        default: return nil
        }
    }
}

// Define the tabs
enum Tab {
    case home
    case profile
    case settings
}

// Custom Tab Bar Component
struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    var accentColor: Color
    
    var body: some View {
        HStack {
            TabBarButton(icon: "house", label: "Home", tab: .home, selectedTab: $selectedTab, accentColor: accentColor)
            
            Spacer()
            
            TabBarButton(icon: "person.circle", label: "Profile", tab: .profile, selectedTab: $selectedTab, accentColor: accentColor)
            
            Spacer()
            
            TabBarButton(icon: "gear", label: "Settings", tab: .settings, selectedTab: $selectedTab, accentColor: accentColor)
        }
        .padding(.horizontal)
        .background(BlurView(style: .systemMaterial)
         .ignoresSafeArea(edges: .bottom))
       
        
        
        
    }
}

// Tab Bar Button Component
struct TabBarButton: View {
    var icon: String
    var label: String
    var tab: Tab
    @Binding var selectedTab: Tab
    var accentColor: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(selectedTab == tab ? accentColor : .gray)
            Text(label)
                .font(.caption)
                .foregroundColor(selectedTab == tab ? accentColor : .gray)
        }
        
        .padding(.top, 12)
        .padding(.bottom,3)
        .padding(.horizontal, 26)
        .onTapGesture {
            selectedTab = tab
        }
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.backgroundColor = .clear // Ensure background is clear for translucency
        return blurView
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
        uiView.backgroundColor = .clear // Ensure background stays clear
    }
}
    

// Home View with location icon for city selection
struct HomeView: View {
    @Binding var showMenu: Bool
    @Binding var selectedCity: String
    @Binding var selectedMenuItem: String
    
    @AppStorage("AccentColor") private var accentColorHex: String = "#FF0000" // Default color as a hex string

    var body: some View {
        NavigationView {
            VStack {
                headerView
                Spacer()
                contentView
                
                
            }
        }
    }

    private var headerView: some View {
        HStack {
            Button(action: {
                withAnimation { showMenu = true }
            }) {
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .padding()
                    .foregroundColor(Color(hex: accentColorHex))
            }
            Text("Nepal Compass")
                .font(.headline)
            Spacer()
            citySelectionMenu
        }
        .padding(.horizontal)
    }

    private var citySelectionMenu: some View {
        Menu {
            Button("General") { selectedCity = "General"}
            Button("Kathmandu") { selectedCity = "Kathmandu" }
            Button("Pokhara") { selectedCity = "Pokhara" }
            Button("Bhaktapur") { selectedCity = "Bhaktapur" }
        } label: {
            Image(systemName: "mappin.circle")
                .font(.title2)
                .padding()
                .foregroundColor(Color(hex: accentColorHex))
        }
    }

    private var contentView: some View {
        ScrollView(showsIndicators: false) {
            DynamicContentView(city: $selectedCity, menuItem: $selectedMenuItem)
        }
    }

    
}

// Profile View with placeholder content
struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Currency converter")
                .font(.title)
                .padding()
            Spacer()
        }
        .navigationTitle("Profile")
    }
}


// Dynamic Content View
struct DynamicContentView: View {
    @Binding var city: String
    @Binding var menuItem: String

    @State private var contentData: [ContentItem] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if contentData.isEmpty {
                VStack {
                        Text("No content available for \(city) in \(menuItem).")
                             .font(.headline)
                             .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity) 
            } else {
                parseContent(data: contentData)
            }
        }
        .onAppear {
            loadData(for: city, menuItem: menuItem)
        }
        .onChange(of: city) { _ in
            loadData(for: city, menuItem: menuItem)
        }
        .onChange(of: menuItem) { _ in
            loadData(for: city, menuItem: menuItem)
        }
    }

    @ViewBuilder
    private func parseContent(data: [ContentItem]) -> some View {
        ForEach(data) { item in
            switch item.type {
            case .text:
                TextView(text: item.content)
            case .image:
                Image(systemName: item.content) // Placeholder
            case .note:
                NoteView(noteText: item.content)
            case .recommendation:
                RecommendationView(recommendationText: item.content)
            case .table:
                TableView(content: item.content)
            case .list:
                ListView(listItems: item.content)
            case .location:
                Text(item.content)
            }
        }
    }

    private func loadData(for city: String, menuItem: String) {
        guard let url = Bundle.main.url(forResource: "contentData", withExtension: "json") else {
            print("JSON file not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let json = try JSONDecoder().decode(ContentData.self, from: data)

            // Check for city-specific content first
                    if let menuContent = json.menuItems[menuItem] {
                        if let cityContent = menuContent[city] {
                            self.contentData = cityContent
                        } else if let generalContent = menuContent["General"] {
                            // Fallback to "General" content if city-specific data is not available
                            self.contentData = generalContent
                        } else {
                            print("No content available for city: \(city) or menuItem: \(menuItem)")
                        }
                    } else {
                        print("Menu item \(menuItem) not found")
                    }
                } catch {
                    print("Error loading JSON: \(error)")
                }
    }
}

// ContentType enumeration
enum ContentType: String, Decodable {
    case text, image, note, recommendation, table, location, list
}

// ContentItem structure
struct ContentItem: Identifiable, Decodable {
    let id: UUID // Automatically generated ID
    var type: ContentType
    var content: String

    private enum CodingKeys: String, CodingKey {
        case type, content
    }

    init(type: ContentType, content: String) {
        self.id = UUID() // Assign a new UUID if it's not present in JSON
        self.type = type
        self.content = content
    }

    // Custom decoding to handle cases without `id`
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(ContentType.self, forKey: .type)
        self.content = try container.decode(String.self, forKey: .content)
        self.id = UUID() // Generate new UUID
    }
}

// ContentData structure
struct ContentData: Decodable {
    var menuItems: [String: [String: [ContentItem]]]
}

struct ImageView: View {
    var image: String
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .frame(height: 200)
            .padding()
            .cornerRadius(8)
    }
}



struct ListView: View {
    var listItems: String // Expecting list items as a string separated by commas
    
    var body: some View {
        // Split the string into items and trim whitespace
        let items = listItems.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        VStack(alignment: .leading) {
            ForEach(items, id: \.self) { item in
                Text("• \(item)")
                    .padding(.vertical, 2)
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
    }
}


#Preview {
    ContentView()
}
