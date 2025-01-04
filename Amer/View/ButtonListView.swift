import SwiftUI

struct ButtonListView: View {
    @EnvironmentObject var buttonsVM: ButtonsViewModel
    @EnvironmentObject var userVM: UserViewModel // For dynamic font scaling and haptics
    @State var navigateToEdit = false
    @State var selectedButton: Buttons? // Track selected button for editing
    @Environment(\.presentationMode) var presentationMode // To dismiss the view


    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                SectionHeader(title: NSLocalizedString("Active", comment: "Active section title"), color: Color("DarkGreen"))
                
                ButtonGrid(buttons: buttonsVM.buttons.filter { !$0.isDisabled }) { button in
                    handleButtonTap(button)
                }
                .padding()
                
                SectionHeader(title: NSLocalizedString("Disabled", comment: "Disabled section title"), color: .red)
                
                ButtonGrid(buttons: buttonsVM.buttons.filter { $0.isDisabled }) { button in
                    handleButtonTap(button)
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .frame(width: 15, height: 25.5)
                            .foregroundStyle(Color("FontColor"))
                    }
                    
                }
                ToolbarItem(placement: .principal) {
                    Text("Button List")
                        .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 30))) // Dynamic font scaling
                        .foregroundStyle(Color("FontColor"))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddNewButtonView()) {
                        Image("AddButton")
                            .resizable()
                            .frame(width: 43, height: 43)
                            .ignoresSafeArea()
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToEdit) {
                if let buttonToEdit = selectedButton {
//                    AddNewButtonView( buttonToEdit: buttonToEdit)
                    AddNewButtonView(buttonsVM: _buttonsVM, buttonToEdit: buttonToEdit)
                }
            }
        }
    }

    private func handleButtonTap(_ button: Buttons) {
        userVM.triggerHapticFeedback() // Trigger haptic feedback
        print("Button \(button.label) tapped")
    }
}

// MARK: - Section Header View
struct SectionHeader: View {
    let title: String
    let color: Color
    @EnvironmentObject var userVM: UserViewModel // For dynamic font scaling

    var body: some View {
        Text(title)
            .font(Font.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 22))) // Dynamic font scaling
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

    @EnvironmentObject var buttonsVM: ButtonsViewModel
    @EnvironmentObject var userVM: UserViewModel // For dynamic font scaling and haptics
    @State private var navigateToEdit = false
    @State private var showingAlert = false

    var body: some View {
        Button(action: {
            if !button.isDisabled { // Only allow action if button is not disabled
                userVM.triggerHapticFeedback() // Trigger haptic feedback
                action(button)
            }
        }) {
            VStack(spacing: 8) {
                Text(button.icon)
                    .font(.system(size: userVM.scaledFont(baseSize: 30))) // Dynamic font scaling
                    .frame(width: 74, height: 74)
                    .background(button.isDisabled ? Color.gray : Color(button.color)) // Gray out if disabled
                    .cornerRadius(20)
                    .shadow(radius: 4, y: 4)
                Text(button.label)
                    .font(Font.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 16))) // Dynamic font scaling
                    .foregroundStyle(button.isDisabled ? .gray : Color("FontColor")) // Gray out text if disabled
            }
        }
        .contextMenu {
            Button {
                userVM.triggerHapticFeedback() // Trigger haptic feedback
                print("Edit \(button.label)")
                navigateToEdit = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            Button {
                userVM.triggerHapticFeedback() // Trigger haptic feedback
                buttonsVM.toggleDisableButton(button) // Toggle disable status
                print("Disable \(button.label)")
            } label: {
                Label(button.isDisabled ? "Enable" : "Disable", systemImage: button.isDisabled ? "lock.open" : "lock")
            }
            Button(role: .destructive) {
                userVM.triggerHapticFeedback() // Trigger haptic feedback
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
                    buttonsVM.deleteButton(button)
                },
                secondaryButton: .cancel()
            )
        }
        .navigationDestination(isPresented: $navigateToEdit) {
//            AddNewButtonView( buttonToEdit: button)
            AddNewButtonView(buttonsVM: _buttonsVM, buttonToEdit: button)
        }
    }
}

// MARK: - Preview
#Preview {
    ButtonListView()
        .environmentObject(ButtonsViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(MembersViewModel())
    
}
