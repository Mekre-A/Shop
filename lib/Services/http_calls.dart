import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterexamstarter/Components/HomePageComponent/homepage.dart';
import 'package:flutterexamstarter/Exception/DatabaseException.dart';
import 'package:flutterexamstarter/Models/categories.dart';
import 'package:flutterexamstarter/Models/category_product.dart';
import 'package:flutterexamstarter/Provider/MasterProvider.dart';
import 'package:flutterexamstarter/Services/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class HttpCalls {

  static const String baseUrl = "https://finbittesting.pythonanywhere.com";

  static const String categories = "/categories";


  static const Map<String,String> requestHeader = {'Content-Type':'application/json','Accept':'application/json'};


  static Future<CategoryProduct> getProductsForOneCategory(int categoryId) async{
    return await http.get(
      baseUrl + categories + "/$categoryId",
      headers: requestHeader
    ).then((value){
      if(value.statusCode == 200){
        CategoryProduct categoryProduct = categoryProductFromJson(value.body);
        return categoryProduct;
      }
      else{
      return null;

      }
    }).catchError((onError){
        print(onError);
        return null;

    });
  }


  static Future<bool> getCategories(MasterProvider masterProvider, BuildContext context) async{
    SqlDatabase sqlDatabase = SqlDatabase();

    checkForDbError(await sqlDatabase.openDB());

    return await http.get(
      baseUrl + categories,
      headers: requestHeader
    ).then((value)async{
      if(value.statusCode == 200){
        // add new categories to db and provider
        List<Categories> newCategories = categoriesFromJson(value.body);
         checkForDbError(await sqlDatabase.insertIntoCategory(newCategories));
         checkForDbError(await sqlDatabase.getCategoriesFromDb(masterProvider));
         //checkForDbError(false);
         //retrieve each product and add it to db and provider
         List<CategoryProduct> newCategoryProduct = [];
         List<Future> httpCalls = [];

         newCategories.forEach((element) async{
           httpCalls.add(getProductsForOneCategory(element.id));
      });

         Future.wait(httpCalls).then((value)async{
              value.forEach((element) {
                CategoryProduct cp = element;
                if (cp != null) {
                  newCategoryProduct.add(cp);
                }
              });
        checkForDbError(await sqlDatabase.insertIntoProduct(newCategoryProduct));
        checkForDbError(await sqlDatabase.getProductsFromDb(masterProvider));
         }).then((value){

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          masterProvider.setShouldSplashScreenReload = false;
         });

      return true;
      }
      else{
      return false;

      }
    }).catchError((onError){
      handleOnError(onError);
      return false;
    });
  }

 static handleOnError(dynamic onError){
    print(onError);
    if(onError is SocketException){
      Fluttertoast.showToast(
          msg: "Please connect to the internet first",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.black,
          fontSize: 16.0);
    }
    else if(onError is SqDatabaseException){
      Fluttertoast.showToast(
          msg: "Something went wrong trying to access the local database",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  static void checkForDbError(bool status){
    if(!status){
      throw SqDatabaseException();
    }
  }
}