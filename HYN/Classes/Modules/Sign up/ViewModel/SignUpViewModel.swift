//
//  SignUpViewModel.swift
//  HYN
//
//  Created by Hadia Yehia on 11/06/2023.
//

import Foundation
import Firebase
import FirebaseDatabase

class SignUpViewModel{
    var isLoading : Observable<Bool> = Observable(false)
    let defaults = UserDefaults.standard
    var myCustomer : Customer = Customer(first_name: "", last_name: "", email: "", phone: "", verified_email: false, password: "", password_confirmation: "", send_email_welcome: false)
    var userId : Int?
    var favId : Int?
    var cartId : Int?
    var userName : String = ""
    var email = "unregistered_email"
    var ref: DatabaseReference = Database.database().reference().child("usersInfo")
    var res = ""
    var draftOrder = DraftOrder()
    
    func rigesterNewCustomer(customer : Customer){
        draftOrder.lineItems = [LineItems(title: "base", price: "0", quantity: 1)]
        if isLoading.value ?? true{
            return
        }
        isLoading.value = true
        Auth.auth().createUser(withEmail: customer.email, password: customer.password){ authResult , error in
            if let e = error{
                print(e)
                self.res = e.localizedDescription
            }else {
                
                NetworkService.getInstance().postingNewCustomer(customer: CustomerRequest(customer: customer), completionHandler: {result in
                    
                    switch result{
                    case .success(let data):
                        self.userId = data.customer.id
                        self.userName = "\(String(describing: data.customer.firstName)) \(String(describing: data.customer.lastName))"
                        self.res = "success"
//                        NetworkService.getInstance().postingNewDraftOrder(draftOrder: self.draftOrder , completionHandler: {result in
//                            switch result{
//                            case .success(let data):
//                                self.favId = data.draftOrder?.id
//                                self.res = "success"
//                                NetworkService.getInstance().postingNewDraftOrder(draftOrder: self.draftOrder ,completionHandler: {result in
//                                    switch result{
//                                    case .success(let data):
//                                        self.cartId = data.draftOrder?.id
//                                        self.res = "success"
                                        self.isLoading.value = false
                        FireBaseSingleTone.getInstance().child(Auth.auth().currentUser!.uid).setValue(["userId": self.userId,"userName":self.userName,"favId":0,"cartId":0])
                        self.defaults.setValue(self.userName, forKey: "userName")
                        self.defaults.setValue(self.userId, forKey: "userId")
                        print("from signup \(self.userId)")
                        self.defaults.setValue(Auth.auth().currentUser?.uid, forKey: "firUserId")
                        print("nfs el ref ?\(self.defaults.object(forKey: "firUserId"))")
                        print("nfs el user ?\(self.defaults.object(forKey: "userId"))")
//                                        break
//                                    case .failure(let error):
//                                        self.res = "error in cart creation : \(error.localizedDescription)"
////                                        break
//                                    }
//                                })
//                                break
//                            case .failure(let error):
//                                self.res = "error in fav creation : \(error.localizedDescription)"
//                                break
//                            }})
                        break
                    case .failure(let error):
                        self.res = error.localizedDescription
                        break
                    }
                })}}
       
    }
//    func rigesterNewCustomer(customer : Customer)->String{
//        myCustomer = customer
//        var res = ""
//        NetworkService.getInstance().postingNewDraftOrder(completionHandler: {result in
//            switch result{
//            case .success(let data):
//                self.favId = data.draftOrder?.id
//               // customer.tags = data.draftOrder?.id
//                self.myCustomer.tags = "\(self.favId)*"
//                print("7war el tags\(self.favId)")
//                res = "success"
//                NetworkService.getInstance().postingNewDraftOrder(completionHandler: {result in
//                    switch result{
//                    case .success(let data):
//                        self.cartId = data.draftOrder?.id
//                        res = "success"
//                        self.myCustomer.tags.append("\(self.cartId)")
//                        print("7war el tags\(self.cartId)")
////                        Auth.auth().createUser(withEmail: customer.email, password: customer.password){ authResult , error in
////                            if let e = error{
////                                print(e)
////                                res = e.localizedDescription
////                            }else {
////
////                                NetworkService.getInstance().postingNewCustomer(customer: CustomerRequest(customer: self.myCustomer), completionHandler: {result in
////                                    print("7war eltags m3 elcustomer\(self.myCustomer.tags)")
////                                    switch result{
////                                    case .success(let data):
////                                        print("7war eltags m3 elcustomer elly rage3\(data.customer.tags)")
////                                        self.userId = data.customer.id
////                                        if let email = data.customer.email{
////                                            self.email = email}
////                                        self.ref.child(Auth.auth().currentUser!.uid).setValue(["userId": self.userId])
////                                        res = "success"
////                                        break
////                                    case .failure(let error):
////                                        res = error.localizedDescription
////                                        break
////                                    }
////                                })
////                            }
//                       // }
//                        break
//                    case .failure(let error):
//                        res = "error in cart creation : \(error.localizedDescription)"
//                        break
//                    }
//
//                })
//                break
//            case .failure(let error):
//                res = "error in fav creation : \(error.localizedDescription)"
//                break
//            }
//
//        })
//        return res
//    }
}
