//
//  ContentView.swift
//  Spine
//
//  Created by Ailidh Kinney on 20/07/2022.


import SwiftUI
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI



struct MainView: View {
    
    
    @EnvironmentObject var model: ViewModel
    
    
    //Determines which view to show if the user is logged in or not
    var body: some View {
        if model.isUserLoggedIn == false {
            content
        } else {
            TabView {
                
                homepage()
                    .tabItem {
                        Label("Home", systemImage: "house")
                        Text("Home")
                        
                    }
                
                allBooks()
                    .tabItem {
                        Label("Search", systemImage: ("magnifyingglass.circle.fill"))
                    }
                
                profile()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle.fill")
                    }
                
                
            }
            
            
        }
        
        
    }
    

    
    
    
    var content: some View {
        
        
        NavigationView {
            // ScrollView{
            
            
            ZStack {
                Color("Sage")
                    .ignoresSafeArea()
                
                VStack {
                    
                    VStack {
                        Text("Spine.")
                            .font(.custom("KAGE_DEMO_FONT-Black", size: 100))
                            .underline()
                            .padding(.vertical, -5.0)
                            .foregroundColor(Color.white)
                        //.padding([.top, .leading, .trailing])
                        
                        Image("Books spine out ")
                            .resizable()
                            .frame(width: 600, height: 200)
                            .clipShape(Circle())
                            .shadow(color: .gray, radius: 5, x: 0, y: 2)
                            .padding()
                        
                        
                    }
                    TextField("Email", text: $model.email)
                        .frame(width:165, height:20)
                        .font(.custom("Baskerville", size: 20))
                        .padding(.vertical, -5.0)
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                    
                    
                    Rectangle()
                        .frame(width:165, height:1)
                        .foregroundColor(.white)
                    
                    
                    SecureField("Password", text: $model.password)
                        .frame(width:165, height:20)
                        .foregroundColor(.white)
                        .font(.custom("Baskerville", size: 20))
                        .padding(.vertical, -5.0)
                    
                    Rectangle()
                        .frame(width:165, height:1)
                        .foregroundColor(.white)
                    
                    Button {
                        model.login(email: model.email, password: model.password)
                    } label: {
                        Text("Log In")
                            .frame(minWidth: 0, maxWidth: 300)
                            .font(.custom("KAGE_DEMO_FONT-Black", size: 50))
                            .padding(.vertical, -1.0)
                            .foregroundColor(.white)
                            .cornerRadius(40)
                        
                        
                    }
                    
                    NavigationLink(destination: register()) {
                        Text("Register for an account here.")
                            .font(.custom("Baskerville", size: 30))
                            .padding(.vertical, -5.0)
                            .foregroundColor(Color("EerieBlack"))
                        
                    }
                    
                    Spacer()
                }
            }
            .accentColor(Color(.label))
            .onAppear {
                //Check what addStateDidChangeListener means?
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        model.isUserLoggedIn.toggle()
                    }
                }
            }
            
        }
        
    }
    
    
    
    
    
    struct homepage: View {
        
        @EnvironmentObject var model: ViewModel
        
        
        
        
        var body: some View {
            
            NavigationView {
                
                
                ZStack {
                    
                    
                    
                    Color("Sage")
                        .ignoresSafeArea()
                    
                    ScrollView{
                        
                        VStack {
                            
                            
                            
                            
                            // Add name in here
                            Text("Sage.")
                                .font(.custom("KAGE_DEMO_FONT-Black", size: 50))
                                .padding(.vertical, -5.0)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                            
                            Text("Currently Reading")
                                .font(.custom("KAGE_DEMO_FONT-Black", size: 50))
                                .underline()
                                .padding(.vertical, -5.0)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            
                            ScrollView(.horizontal) {
                                
                                HStack {
                                    
                                    ForEach(model.currentlyReading) {book in
                                        
                                        HStack {
                                            Spacer()
                                            
                                            WebImage(url: URL(string: book.cover))
                                                .resizable()
                                                .frame(width: 180, height: 220)
                                            
                                            VStack {
                                                
                                                Text(book.title)
                                                    .font(.custom("KAGE_DEMO_FONT-Black", size: 30))
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                
                                                Text(book.author)
                                                    .font(.custom("KAGE_DEMO_FONT-Black", size: 30))
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                
                                            }
                                            Spacer()
                                        }
                                        
                                        
                                    }
                                }
                            }
                            
                            
                            Spacer()
                            
                            Text("To be read")
                                .font(.largeTitle)
                                .underline()
                                .padding()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ScrollView(.horizontal) {
                                
                                HStack {
                                    
                                    ForEach(model.toBeRead) {book in
                                        
                                        HStack {
                                            Spacer()
                                            
                                            WebImage(url: URL(string: book.cover))
                                                .resizable()
                                                .frame(width: 180, height: 220)
                                            
                                            VStack {
                                                
                                                Text(book.title)
                                                    .font(.title)
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                
                                                Text(book.author)
                                                    .font(.subheadline)
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                
                                            }
                                            Spacer()
                                        }
                                        
                                        
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                }
            }
    
            
        }
    }
    
    
    
    struct register: View {
        
        @EnvironmentObject var model: ViewModel
        
        @State  var newEmail = ""
        @State var newPassword = ""
        @State var confirmPassword = ""
        @State  var dob = Date()
        
        var body: some View {
            
            ZStack {
                Color("Sage")
                    .ignoresSafeArea()
                
                VStack {
                    
                    Text("Enter your details")
                        .font(.custom("KAGE_DEMO_FONT-Black", size: 55))
                        .padding(.vertical, -3.0)
                        .foregroundColor(Color("EerieBlack"))
                        .padding()
                    
                    TextField("Name", text: $model.name)
                        .padding(.leading, 10.0)
                        .foregroundColor(.white)
                        .font(.custom("Baskerville", size: 30))
                    
                    Rectangle()
                        .frame(width:400, height:1)
                        .foregroundColor(Color("Ebony"))
                    
                    
                    HStack {
                        
                        Text("Date of Birth")
                            .foregroundColor(.white)
                            .font(.custom("Baskerville", size: 30))
                            .padding(.leading, 10.0)
                        
                        
                        DatePicker (
                            "",
                            selection: $dob,
                            displayedComponents: [.date]
                        ).accentColor(.black)
                            .padding()
                        
                    }
                    
                    TextField("Email address", text: $newEmail)
                        .foregroundColor(.white)
                        .padding(.leading, 10.0)
                        .font(.custom("Baskerville", size: 30))
                        .autocapitalization(.none)
                    
                    
                    
                    Rectangle()
                        .frame(width:400, height:1)
                        .foregroundColor(Color("ArmyGreen"))
                    
                    VStack {
                        
                        SecureField("Password", text: $newPassword)
                            .foregroundColor(.white)
                            .padding(.leading, 10.0)
                            .font(.custom("Baskerville", size: 30))
                            .autocapitalization(.none)
                        
                        Rectangle()
                            .frame(width:400, height:1)
                            .foregroundColor(Color("ArmyGreen"))
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .foregroundColor(.white)
                            .padding(.leading, 10.0)
                            .font(.custom("Baskerville", size: 30))
                            .autocapitalization(.none)
                        
                        Rectangle()
                            .frame(width:400, height:1)
                            .foregroundColor(Color("ArmyGreen"))
                        
                        Spacer()
                        
                        Button {
                            model.registerUser(email: newEmail, password: newPassword)
                        } label: {
                            Text("Register")
                                .foregroundColor(Color("EerieBlack"))
                                .underline()
                                .bold()
                                .font(.custom("KAGE_DEMO_FONT-Black", size: 60))
                                .padding()
                        }
                        
                        Text(model.userAccountStatusMessage)
                            .foregroundColor(.white)
                            .padding([.leading, .trailing])
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
            .onAppear {
                //Check what addStateDidChangeListener means?
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        model.isUserLoggedIn.toggle()
                    }
                }
            }
            
            
        }
        
        
    }
    
    struct allBooks: View {
        
        @ObservedObject var model = ViewModel()
        
        init() {
            UITableView.appearance().separatorStyle = .none
            UITableViewCell.appearance().backgroundColor = .clear
            UITableView.appearance().backgroundColor = .clear
            
        }
        
        
        var body: some View {
            
            
            NavigationView {
                
                
                ZStack {
                    
                    Color("Sage")
                        .ignoresSafeArea(.all)
                    
                    ScrollView {
                        
                        VStack {
                            
                            ForEach(model.list) {book in
                                
                                VStack {
                                    
                                    HStack {
                                        
                                        VStack {
                                            Text(book.title)
                                                .font(.title)
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text(book.author)
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            HStack {
                                                Button (action: {
                                                    model.handleAddToCurrentlyReading(author: book.author, title: book.title, genre: book.genre, cover: book.cover, id: book.id)
                                                }, label: {
                                                    Image(systemName: "plus")
                                                        .foregroundColor(.white)
                                                    Text("Currently Reading")
                                                        .foregroundColor(.white)
                                                        .font(.footnote)
                                                        .underline()
                                                })
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .buttonStyle(BorderlessButtonStyle())
                                                
                                                
                                                
                                                Button  (action: {
                                                    model.handleAddToToBeRead(author: book.author, title: book.title, genre: book.genre, cover: book.cover, id: book.id)
                                                }, label: {
                                                    Image(systemName: "plus")
                                                        .foregroundColor(.white)
                                                    Text("To be read")
                                                        .foregroundColor(.white)
                                                        .font(.footnote)
                                                        .underline()
                                                })
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .buttonStyle(BorderlessButtonStyle())
                                                
                                                
                                            }
                                        }
                                        
                                        
                                        
                                        
                                        
                                        WebImage(url: URL(string: book.cover))
                                            .resizable()
                                            .frame(width: 80, height: 100)
                                        
                                        //Only add if necessary later
                                        /*  Button  (action: {
                                         //see more about book
                                         }, label: {
                                         Image(systemName: "arrowshape.turn.up.right.circle")
                                         }) */
                                        
                                        
                                    }
                                    
                                    
                                    
                                }
                                
                            }
                            .background(Color("Sage"))
                        }
                        .padding()
                        
                        
                    }
                    
                    
                }
            }
            
            
        }
        
        
    }
    
    struct profile: View {
        
        @EnvironmentObject var model: ViewModel
        
        var body: some View {
            
            ZStack {
                
                
                Color("Sage")
                    .ignoresSafeArea(.all)
                
                VStack {
                    
                    NavigationLink (destination: Text("Personal info"), label: {
                        Text("Personal Info")
                    })
                    
                    
                    Button {
                        
                        model.signOut()
                        
                    } label: {
                        Text("Sign out")
                    }
                    
                }
                
            }
            
        }
        
        
        
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            MainView()
        }
    }
    
    
    struct homepage_Previews: PreviewProvider {
        static var previews: some View {
            homepage()
        }
    }
    
    struct register_Previews: PreviewProvider {
        static var previews: some View {
            register()
        }
    }
    
    struct search_Previews: PreviewProvider {
        static var previews: some View {
            allBooks()
        }
    }
}




