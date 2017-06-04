//
//  IAPManager.swift
//  tickadate
//
//  Created by Romain Bessuges-Meusy on 02/06/2017.
//  Copyright © 2017 Agilitation. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit


enum ProductIDs : String {
  case threeAdditionalEventTypes = "com.agilitation.tickadate.3-PACK"
  case unlimitedEventTypes = "com.agilitation.tickadate.UNLIMITED"
}

class IAPManager: NSObject {

  static let shared:IAPManager = IAPManager()
  
  var activeColorSwatches:[ColorSwatch] = []
  
  var eventTypesCount:Int = 6
  
  var products:[String:SKProduct] = [:]
  
  func retreiveProductsInfo(completion: @escaping () -> ()) {
    
    if products.count > 0 {
      completion()
      return
    }
    
    SwiftyStoreKit.retrieveProductsInfo([
      ProductIDs.threeAdditionalEventTypes.rawValue,
      ProductIDs.unlimitedEventTypes.rawValue
    ]) { result in
      result.retrievedProducts.forEach({ (product) in
        self.products[product.productIdentifier] = product
      })
      completion()
    }
  }
  
  func purchase(_ productID:ProductIDs, completion: @escaping () -> ()){
    
    retreiveProductsInfo {
      if self.products[productID.rawValue] == nil {
        print("no product found for ID", productID.rawValue)
        return
      }
      SwiftyStoreKit.purchaseProduct(self.products[productID.rawValue]!, completion: { (result) in
        switch result {
        case .success(let purchase):
          print("Purchase Success: \(purchase.productId)")
          completion()
        case .error(let error):
          switch error.code {
          case .unknown: print("Unknown error. Please contact support")
          case .clientInvalid: print("Not allowed to make the payment")
          case .paymentCancelled: break
          case .paymentInvalid: print("The purchase identifier was invalid")
          case .paymentNotAllowed: print("The device is not allowed to make the payment")
          case .storeProductNotAvailable: print("The product is not available in the current storefront")
          case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
          case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
          case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
          }
        }
      })
    }
  }
  
}