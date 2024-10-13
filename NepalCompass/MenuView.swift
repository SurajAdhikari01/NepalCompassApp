import SwiftUI

struct MenuView: View {
    @Binding var showMenu: Bool
    @Binding var selectedMenuItem: String
    @AppStorage("AccentColor") private var accentColorHex: String = "#FF0000" // Default color as a hex string
    
    let menuSections: [MenuSectionItem] = [
        MenuSectionItem(title: "Getting Started", items: [
            MenuItem(title: "Arriving in Nepal", icon: "airplane.arrival"),
            MenuItem(title: "Accommodation", icon: "house"),
            MenuItem(title: "Getting Around", icon: "car")
        ]),
        MenuSectionItem(title: "Food and Drink", items: [
            MenuItem(title: "Local Cuisine", icon: "fork.knife"),
            MenuItem(title: "Continental Cuisine", icon: "globe"),
            MenuItem(title: "Street Food", icon: "cart")
        ]),
        MenuSectionItem(title: "Sightseeing and Activities", items: [
            MenuItem(title: "Trekking and Hiking", icon: "figure.walk")
        ]),
        MenuSectionItem(title: "Shopping", items: [
            MenuItem(title: "Handicrafts", icon: "scissors"),
            MenuItem(title: "Souvenirs", icon: "gift"),
            MenuItem(title: "Local Markets", icon: "cart.fill")
        ]),
        MenuSectionItem(title: "Practical Information", items: [
            MenuItem(title: "Safety and Health", icon: "cross.case"),
            MenuItem(title: "Money Matters", icon: "banknote"),
            MenuItem(title: "Local Etiquette and Customs", icon: "person.fill.questionmark"),
            MenuItem(title: "Language and Communication", icon: "message"),
            MenuItem(title: "Travel Tips and Resources", icon: "book")
        ])
    ]
    
    var body: some View {
        
        
        NavigationView {
            List {
                ForEach(menuSections) { section in
                    MenuSection(
                        title: section.title,
                        items: section.items,
                        selectedMenuItem: $selectedMenuItem,
                        showMenu: $showMenu
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showMenu.toggle() // Toggle menu with animation
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .padding()
                                .foregroundColor(Color(hex: accentColorHex))
                        }
                        Text("Nepal Compass")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    .padding(.vertical)
                }
            }
        }
    }
}

struct MenuSection: View {
    let title: String
    let items: [MenuItem]
    
    @Binding var selectedMenuItem: String
    @Binding var showMenu: Bool
    
    @AppStorage("AccentColor") private var accentColorHex: String = "#FF0000" // Default color as a hex string
    @State private var highlightedItem: String?
    var body: some View {
        Section(header: Text(title)
            .font(.headline)
            .padding(.leading, 0)
            .padding(.bottom, 4)
        ) {
            ForEach(items) { item in
                HStack {
                    Image(systemName: item.icon)
                        .font(.system(size: 24)) // Fixed icon size
                        .foregroundColor(Color(hex: accentColorHex))
                        .frame(width: 30, height: 15) // Fixed frame for alignment
                        .padding(.horizontal ,10)
                    
                        
                    Text(item.title)
                        .font(.body)
                        .foregroundColor(selectedMenuItem == item.title ? Color(hex: accentColorHex) : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading) // Ensures text starts at the same point
                        //.padding(.horizontal, 10)
                    
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .font(.system(size: 18)) // Fixed icon size
                        .foregroundColor(.primary)
                        .frame(width: 30, height: 15) // Fixed frame for alignmen
                        .padding(.horizontal ,10)
                        
                }
                
                
                .padding(.vertical, 10)
                .background(highlightedItem == item.title ? Color(hex: accentColorHex).opacity(0.3) : Color.clear) // Highlight with noticeable color
                .contentShape(Rectangle())
                .cornerRadius(10) // Optional: Add rounded corners for better visuals
                
                .onTapGesture {
                                    // Highlight the tapped item
                                    highlightedItem = item.title
                                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                            // Perform the slide-out animation after the highlight is visible
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                selectedMenuItem = item.title
                                                showMenu = false // Trigger the closing (slide-out) animation
                                            }
                                        }
                                    
                                    // Remove the highlight after the animation completes
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        highlightedItem = nil
                                    }
                                }
                
            }
            
        }
        
    }
    
}

struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
}

struct MenuSectionItem: Identifiable {
    let id = UUID()
    let title: String
    let items: [MenuItem]
}

#Preview {
    MenuView(showMenu: .constant(true), selectedMenuItem: .constant("Arriving in Nepal"))
}
