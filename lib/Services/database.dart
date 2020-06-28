import 'package:flutter/foundation.dart';
import 'package:flutterexamstarter/Models/categories.dart';
import 'package:flutterexamstarter/Models/category_product.dart';
import 'package:flutterexamstarter/Provider/MasterProvider.dart';
import 'package:flutterexamstarter/Services/http_calls.dart';
import 'package:sqflite/sqflite.dart';

class SqlDatabase {

  Database database;

  Future<bool> openDB() async{
    String path = await getPath();
    database = await openDatabase(path,version: 1,onCreate: (Database db, int version) async{
      await db.execute('CREATE TABLE category(id INTEGER primary key, categoryname TEXT)');
      await db.execute('CREATE TABLE product(id INTEGER, productname TEXT, description TEXT, productprice real, category INTEGER , image_url text, foreign key (category) references category(id))');
    }) ;
    print(database.isOpen);

    return true;
  }

  Future<bool> insertIntoCategory(List<Categories> category) async{
    await database.execute('delete from category');
    List<Future> dbInsertCalls = [];
    category.forEach((element) async{
      dbInsertCalls.add(database.insert("category", {'id':element.id, 'categoryname':element.name }));
    });
    
   return await Future.wait(dbInsertCalls,eagerError: true).then((value){
      return true;
    }).catchError((onError){
      return false;
    });


  }
  
  Future<bool> getCategoriesFromDb(MasterProvider masterProvider) async{
    List<Map<String,dynamic>> hello = [];
    List<Categories> newCategories = [];
    return await database.rawQuery('select * from category').then((value){
      hello = value;
      hello.forEach((element) {
        newCategories.add(Categories(id: element['id'], name: element['categoryname']));
      });
      masterProvider.setCategories = newCategories;
      return true;
    }).catchError((onError){
      return false;
    });

    
    
  }

  Future<bool> insertIntoProduct(List<CategoryProduct> categoryproduct) async{
    await database.delete("product");

    List<Future> dbInsertCalls = [];
    categoryproduct.forEach((element) async{
      element.products.forEach((e) async{
        dbInsertCalls.add(database.insert('product', {'id':e.id,'productname':e.name, 'description':e.description, 'productprice':e.price, 'category':element.id, 'image_url':e.imageUrl}));
      });
    });

    return await Future.wait(dbInsertCalls,eagerError: true).then((value){
      return true;
    }).catchError((onError){
      return false;
    });

  }

  Future<bool> getProductsFromDb(MasterProvider masterProvider) async{

    // categories in the form of maps so we can easily refer to the list of categories that we have
    Map<String,String> categories = {};
    masterProvider.getCategories.forEach((element) {
      categories[element.id.toString()] = element.name;
    });

    // used to track which categories have been created
    List<int> existingId = [];
    // our newly created categoryProducts
    List<CategoryProduct> categoryProducts = [];

    List<Map<String, dynamic>> categoryProductsFromDB = [];

    return await database.rawQuery('select * from product').then((value){
      categoryProductsFromDB = value;
      categoryProductsFromDB.forEach((product) {
        if(existingId.contains(product['category'])){

          for(CategoryProduct e in categoryProducts){
            if(e.id == product['category']){
              e.addNewProduct(Product(id: product['id'],name: product['productname'],description: product['description'],price: product['productprice'],category: product['category'],imageUrl: product['image_url']));
              break;
            }
          }
        }
        else{
          existingId.add(product['category']);
          categoryProducts.add(CategoryProduct(id: product['category'], name: categories[product['category'].toString()],products: [Product(id: product['id'],name: product['productname'],description: product['description'],price: product['productprice'],category: product['category'],imageUrl: product['image_url'])]));
        }
      });
      masterProvider.setCategoryProducts = categoryProducts;
      return true;
    }).catchError((onError){
      return false;
    });

  }

  Future<String> getPath() async{
    String path = await getDatabasesPath();
    return path + 'shop.db';
  }

  Future<bool> loadDataFromDb(MasterProvider masterProvider)async{
   return await openDB().then((value)async{
      if(value){
        return await getCategoriesFromDb(masterProvider).then((value)async{
          if(value){
            return await getProductsFromDb(masterProvider).then((value){
              if(value){
                return true;
              }
              else{
                return false;
              }
            }).catchError((onError){
              return false;
            });
          }
          else{
            return false;
          }
        }).catchError((onError){
          return false;
        });
      }
      else{
        return false;
      }
    }).catchError((onError){
      return false;
    });


  }


}