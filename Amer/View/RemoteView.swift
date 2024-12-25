import SwiftUI



struct RemoteView: View {
    @EnvironmentObject var vm: ButtonsViewModel
    // @enviromentobject for userviewmodel to take the user name
    let maxItems = 9
   // @State var buttonslist:[Buttons]
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                VStack {
                    VStack {
                        HStack {
                            Text("Hello Mama Munerah")
                                .font(Font.custom("Tajawal-Bold", size: 28))
                                .foregroundColor(Color("FontColor")).padding(.trailing,90)
                            
                        }
                        .padding(.top, 30)
                        
                        Divider()
                            .frame(width: UIScreen.screenWidth - 40, height: 2)
                            .overlay(Color(hex: 0xE8F6FF))
                            .padding(.top, 8)
                        Spacer()
                    }
                    VStack(spacing:32) {
                        // Check if the button list is not empty
                     //   Spacer()
                        if (!vm.buttons.isEmpty) {
                            
                            
                            
                            let buttonsToDisplay = Array(vm.buttons.prefix(maxItems))
                            // LazyVGrid for 3 columns
                            LazyVGrid(columns: [
                                GridItem(.fixed(76),spacing: 40),
                                GridItem(.fixed(76),spacing: 40),
                                GridItem(.fixed(76),spacing: 40)
                            ], spacing: 40) {
                                ForEach(buttonsToDisplay) { button in
                                    Button(action: {
                                        // Define button action here
                                        print("Button \(button.label) tapped")
                                    }) {
                                        VStack(spacing: 8) {
                                            Text(button.icon)
                                                .font(.system(size: 30))
                                                .frame(width: 74,height: 74)
                                                .background(Color(button.color))
                                                .cornerRadius(20)
                                                .shadow(radius: 4, y: 4)
                                            Text(button.label)
                                                .font(Font.custom("Tajawal-Bold", size: 16))
                                                .foregroundStyle(Color("FontColor"))
                                        }
                                    }
                                }
                            }
                            
                            // Bell Button
                            Button(action: {
                                print("Bell button tapped")
                            }) {
                                VStack(spacing: 8) {
                                    Text("🔔")
                                        .font(.system(size: 30))
                                        .frame(width: 114,height: 114)
                                        .background(Color("DarkBlue"))
                                        .cornerRadius(60)
                                        .shadow(radius: 4, y: 4)
                                    Text("Bell")
                                        .font(Font.custom("Tajawal-Bold", size: 16))
                                        .foregroundStyle(Color("FontColor"))
                                }
                            }
                           // Spacer()
                            
                        } else {
                            
                            
                            
                            Spacer()
                            Button(action: {
                                // Add Bell button action here
                                print("Bell button tapped")
                            }) {
                                VStack(spacing: 16) {
                                    Text("🔔")
                                        .font(.system(size: 70))
                                        .frame(width: 220,height: 220)
                                        .background(Color("DarkBlue"))
                                        .cornerRadius(120)
                                        .shadow(radius: 4, y: 4)
                                    
                                    Text("Bell")
                                        .font(Font.custom("Tajawal-Bold", size: 30))
                                        .foregroundStyle(Color("FontColor"))
                                }
                            }
                            
                            Spacer()
                            Spacer()
                            Spacer()
                            
                        }
                        
                        
                    }
                }
                .padding(.bottom, 50)
                
                
             
                
                  //  .padding(.top, 40)
                
                .toolbar {
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: ButtonListView().navigationBarBackButtonHidden(true)) {
                            Image("AddButton")
                                .resizable()
                                .frame(width: 43, height: 43)
                                .ignoresSafeArea().padding(.trailing,10)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        
                        NavigationLink(destination: ProfileView().navigationBarBackButtonHidden(true)) {
                            
                            Image("Reciver_user")
                                .resizable()
                                .frame(width: 43, height: 43)
                            
                            
                        }
                        VStack {
                            Text("Hello Mama Munerah")
                                .font(Font.custom("Tajawal-Bold", size: 28))
                                .foregroundColor(Color("FontColor"))
                            Divider()
                                .frame(width: UIScreen.screenWidth - 40, height: 2)
                                .overlay(Color(hex: 0xE8F6FF))
                                .padding(.top, 8)
                        }
                        
                        
                        
                    }
                    
                    
                }
            }
            }
        }
    }


#Preview {
    RemoteView()
        .environmentObject(ButtonsViewModel())
}

class ButtonsViewModl: ObservableObject {
    @Published var buttons: [Buttons] = []

    init(sampleData: Bool = false) {
        if sampleData {
            buttons = [
                Buttons(label: "Button 1", icon: "🔑", color: Color.blue),
                Buttons(label: "Button 2", icon: "📞", color: Color.green),
                Buttons(label: "Button 3", icon: "📷", color: Color.red),
                Buttons(label: "Button 4", icon: "🎮", color: Color.purple),
                Buttons(label: "Button 5", icon: "🎵", color: Color.orange),
                Buttons(label: "Button 6", icon: "📁", color: Color.yellow)
            ]
        }
    }
}


// to pick color in hex format Color(hex:0x000000) used like this
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double((hex >> 0) & 0xff) / 255,
            opacity: alpha
        )
    }
}

// to make the interfaces responsive to each device we use this extension
// to use UIScreen.screenWidth for example
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
