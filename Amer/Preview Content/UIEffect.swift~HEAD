//
//  UIEffect.swift
//  Amer
//
//  Created by Noori on 25/12/2024.
//



import SwiftUI

/// Primary button style with a pressed effect.
struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Color("DarkBlue")
            configuration.label
                .font(.custom("Tajawal-Bold", size: 20))
                .foregroundColor(.white)
        }
        .frame(height: 52)
        .cornerRadius(8)
        .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        .opacity(configuration.isPressed ? 0.8 : 1.0)
        .animation(.easeInOut, value: configuration.isPressed)
    }
}


/// Secondary button style with a pressed effect.
struct GreenButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Color("DarkGreen")
            configuration.label
                .font(.custom("Tajawal-Bold", size: 20))
                .foregroundColor(.white)
        }
        .frame(height: 52)
        .cornerRadius(8)
        .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        .opacity(configuration.isPressed ? 0.8 : 1.0)
        .animation(.easeInOut, value: configuration.isPressed)
    }
}




/// Secondary button style with a pressed effect.
struct LightGreenButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Color("ColorGreen")
            configuration.label
                .font(.custom("Tajawal-Bold", size: 20))
                .foregroundColor(.white)
        }
        .frame(height: 52)
        .cornerRadius(8)
        .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        .opacity(configuration.isPressed ? 0.8 : 1.0)
        .animation(.easeInOut, value: configuration.isPressed)
    }
}




struct cancelGreen: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Color.clear
            configuration.label
                .font(.custom("Tajawal-Bold", size: 20))
                .foregroundColor(Color("DarkGreen"))
        }
        .frame(height: 52)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color("DarkGreen"), lineWidth: 2) // Added border with the same color as text
        )
        .cornerRadius(8)
        .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        .opacity(configuration.isPressed ? 0.8 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}


struct cancelGrayBlue: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Color("LightBlue")
            configuration.label
                .font(.custom("Tajawal-Bold", size: 20))
                .foregroundColor(Color("DarkBlue"))
        }
        .frame(height: 52)
        .cornerRadius(8)
        .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        .opacity(configuration.isPressed ? 0.8 : 1.0)
        .animation(.easeInOut, value: configuration.isPressed)
    }
}

struct UIEffect: View {
    var body: some View {
        
        Button("BlueButton") {
            
        }.buttonStyle(BlueButton()).padding()
        
        Button("GreenButton") {
            
        }.buttonStyle(GreenButton()).padding()
        
        Button("LightGreenButton") {
            
        }.buttonStyle(LightGreenButton()).padding()
        
        Button("cnacleGreen") {
            
        }.buttonStyle(cancelGreen()).padding()
        
        Button("cancleGrayBlue") {
            
        }.buttonStyle(cancelGrayBlue()).padding()
        
    }
    
}


#Preview {
    UIEffect()
}
