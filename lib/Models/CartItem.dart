import 'package:flutter/material.dart';
import 'package:flutterexamstarter/Models/category_product.dart';

class CartItem{

  CartItem({@required int count, @required Product product}):_count = count, _product = product;

  int _count;
  int get getCount => _count;

  Product _product;
  Product get getProduct => _product;

  double get getPrice{
    return _product.price;
  }

  int addAmount(){
    return (_count +=1);
  }

  int subtractAmount(){
    return (_count -=1);
  }
}