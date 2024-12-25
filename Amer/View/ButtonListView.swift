import SwiftUI

struct ButtonListView: View {
    @EnvironmentObject var vm: ButtonsViewModel
    @State var navigateToEdit = false
    @State var selectedButton: Buttons? // Track selected button for editing
    var buttonToDelete: Buttons?
    //var button: Buttons
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                SectionHeader(title: "Active", color: Color("DarkGreen"))
                
                ButtonGrid(buttons: vm.buttons) { button in
                    handleButtonTap(button)
                }
                .padding()
                
                SectionHeader(title: "Disabled", color: .red)
                
                ButtonGrid(buttons: []) { button in
                    handleButtonTap(button)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: RemoteView().navigationBarBackButtonHidden(true)) {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .frame(width: 15, height: 25.5)
                            .foregroundStyle(Color("DarkBlue"))
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Button List")
                        .font(.custom("Tajawal-Bold", size: 30))
                        .foregroundStyle(Color("FontColor"))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddNewButtonView().navigationBarBackButtonHidden(true)) {
                        Image("AddButton")
                            .resizable()
                            .frame(width: 43, height: 43)
                            .ignoresSafeArea()
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToEdit) {
                if let buttonToEdit = selectedButton {
                    AddNewButtonView(vm: _vm, buttonToEdit: buttonToEdit)
                }
            }
        }
    }

    private func handleButtonTap(_ button: Buttons) {
        print("Button \(button.label) tapped")
    }
}


// MARK: - Section Header View
struct SectionHeader: View {
    let title: String
    let color: Color
    
    var body: some View {
        Text(title)
            .font(Font.custom("Tajawal-Bold", size: 22))
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
}

// MARK: - Button Grid View
struct ButtonGrid: View {
    let buttons: [Buttons]
    let action: (Buttons) -> Void

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color("Background"))
                .cornerRadius(20)
                .frame(height: 270)

            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.fixed(76), spacing: 32),
                    GridItem(.fixed(76), spacing: 32),
                    GridItem(.fixed(76), spacing: 32)
                ], spacing: 32) {
                    ForEach(buttons) { button in
                        ButtonView(button: button, action: action)
                    }
                }
                .padding(.top, 20)
                
            }
        }
    }
}

// MARK: - Individual Button View
struct ButtonView: View {
    let button: Buttons
    let action: (Buttons) -> Void

    @EnvironmentObject var vm: ButtonsViewModel
    @State private var navigateToEdit = false
    @State private var showingAlert = false

    var body: some View {
        Button(action: {
            action(button)
        }) {
            VStack(spacing: 8) {
                Text(button.icon)
                    .font(.system(size: 30))
                    .frame(width: 74, height: 74)
                    .background(Color(button.color))
                    .cornerRadius(20)
                    .shadow(radius: 4, y: 4)
                Text(button.label)
                    .font(Font.custom("Tajawal-Bold", size: 16))
                    .foregroundStyle(Color("FontColor"))
            }
        }
        .contextMenu {
            Button {
                print("Edit \(button.label)")
                navigateToEdit = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            Button {
                print("Disable \(button.label)")
            } label: {
                Label("Disable", systemImage: "doc.on.doc")
            }
            Button(role: .destructive) {
                print("Delete \(button.label)")
                showingAlert = true
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Delete a Button"),
                message: Text("Are you sure you want to delete this button?"),
                primaryButton: .destructive(Text("Delete")) {
                    vm.deleteButton(button)
                },
                secondaryButton: .cancel()
            )
        }
        .navigationDestination(isPresented: $navigateToEdit) {
            AddNewButtonView(vm: _vm, buttonToEdit: button)
        }
    }
}



// MARK: - Preview
#Preview {
    ButtonListView()
       // .environmentObject(ButtonsViewModel(sampleData: true))
}


