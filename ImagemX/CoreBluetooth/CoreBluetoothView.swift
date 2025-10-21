//
//  CoreBluetoothView.swift
//  ImagemX
//
//  Created by Débora Cristina Silva Ferreira on 16/10/25.
//

import SwiftUI
import CoreBluetooth

struct CoreBluetoothView: View {
    @StateObject private var viewModel = CoreBluetoothViewModel()
    @State private var selectedPeripheral: CBPeripheral?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Button("Detectável") {
                        viewModel.setMode(newMode: .send)
                    }
                    .padding()
                    .background(viewModel.bleMode == .send ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Procurar") {
                        viewModel.setMode(newMode: .receive)
                    }
                    .padding()
                    .background(viewModel.bleMode == .receive ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                Divider()
                
                if(viewModel.bleMode == .receive){
                    Text("Dispositivos Descobertos")
                        .font(.headline)
                    List(viewModel.discoveredPeripherals, id: \.identifier) { peripheral in
                        HStack {
                            Text(peripheral.name ?? "Sem Nome")
                            Spacer()
                            Button(viewModel.connectedPeripheral != nil ? "Desconectar" : "Conectar") {
                                if viewModel.connectedPeripheral == peripheral {
                                    viewModel.desconnect(peripheral: peripheral)
                                    selectedPeripheral = nil
                                } else {
                                    viewModel.connect(peripheral: peripheral)
                                    selectedPeripheral = peripheral
                                }
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                } else {
                    Text("Centrais conectadas")
                        .font(.headline)
                    if viewModel.connectedCentrals.isEmpty {
                        VStack{
                            Text("Aguardando conexão")
                            ProgressView()
                        }
                    } else {
                            VStack {
                                Text("Conectado. Toma!")
                                Image("mamaco")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity, maxHeight: 500)
                            }
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle("BLE Dispositivos")
        }
    }
}

#Preview {
    CoreBluetoothView()
}
