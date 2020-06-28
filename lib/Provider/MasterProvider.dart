import 'package:flutter/material.dart';
import 'package:flutterexamstarter/Models/CartItem.dart';
import 'package:flutterexamstarter/Models/categories.dart';
import 'package:flutterexamstarter/Models/category_product.dart';

class MasterProvider extends ChangeNotifier{

  List<Categories> _categories = [];
  List<Categories> get getCategories => _categories;
  set setCategories(List<Categories> newCategories){
    _categories = newCategories;
  }

  List<CategoryProduct> _categoryProducts = [];
  List<CategoryProduct> get getCategoryProducts => _categoryProducts;
  set setCategoryProducts(List<CategoryProduct> newCategoryProducts){
    _categoryProducts = newCategoryProducts;
  }

  bool _shouldSplashScreenReload = false;
  get getShouldSplashScreenReload => _shouldSplashScreenReload;
  set setShouldSplashScreenReload(bool status){
    _shouldSplashScreenReload = status;
    notifyListeners();
  }

  List<Map<String,int>> _cartListTracker = [];
  List<Map<String,int>> get getCartListTracker => _cartListTracker;
  set setCartListTracker(List<Map<String,int>> productList){
    _cartListTracker = productList;
    notifyListeners();
  }
  set addToTrackerList(Map<String,int> newProduct){
    _cartListTracker.add(newProduct);
    notifyListeners();
  }

  List<CartItem> _cartItems = [];
  List<CartItem> get getCartItemList => _cartItems;
  set setCartItems(List<CartItem> newCartList){
    _cartItems = newCartList;
  }
  set addToCartItemList(CartItem newCartItem){
    _cartItems.add(newCartItem);
  }
  set addCountOfCartItem(Map<String,int> tracker){
    for(CartItem car in getCartItemList){
      if(car.getProduct.id == tracker['product_id'] && car.getProduct.category == tracker['category_id'] ){
        car.addAmount();
        print("The count of ${car.getProduct.name} has been added, the new count is ${car.getCount}");
        break;
      }
    }

  }

  bool _checkingOut = false;
  bool get getCheckingOut => _checkingOut;
  set setCheckingOut(bool value){
    _checkingOut = value;
    notifyListeners();
  }


  double _total = 0.0;
  double get getTotal => _total;
  set setTotalBySingleValue(double value){
    _total = _total + value;
    notifyListeners();
  }
  set setTotal(double value){
    _total = value;
  }




}