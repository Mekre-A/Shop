import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterexamstarter/Models/CartItem.dart';
import 'package:flutterexamstarter/Models/category_product.dart';
import 'package:flutterexamstarter/Provider/MasterProvider.dart';
import 'package:provider/provider.dart';

class SingleProductLandscape extends StatelessWidget{
  final CategoryProduct categoryProduct;
  final int index;

  SingleProductLandscape(this.categoryProduct,this.index);

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen: false);
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: categoryProduct.products[index].imageUrl,
            imageBuilder: ((context, imageProvider){
              return Container(
                height: 350,
                width: 350,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain
                    )
                ),
              );
            }),
            placeholder: (context,url) => CircularProgressIndicator(),
          ),

          Container(
            width: MediaQuery.of(context).size.width/2.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  categoryProduct.products[index].name,
                  maxLines:1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                Text(
                    "${categoryProduct.products[index].description} ",
                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                    maxLines:2
                ),
                Text("${categoryProduct.products[index].price} birr",),
                SizedBox(height: 10,),
                RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.add_shopping_cart,color: Colors.white,),
                        Text("Add to cart",style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                  onPressed: (){
                    if(masterProvider.getCartListTracker.length == 0){
                      masterProvider.addToTrackerList = {
                        "category_id":categoryProduct.id,
                        "product_id":categoryProduct.products[index].id,

                      };
                      masterProvider.addToCartItemList = CartItem(count: 1, product: categoryProduct.products[index]);
                      masterProvider.setTotalBySingleValue = categoryProduct.products[index].price;
                      Navigator.pop(context);
                    }
                    else {
                      bool isItemFound = false;
                      for( Map map in masterProvider.getCartListTracker){
                        if(map['category_id'] == categoryProduct.id && map['product_id'] == categoryProduct.products[index].id){
                          masterProvider.addCountOfCartItem = map;
                          masterProvider.setTotalBySingleValue = categoryProduct.products[index].price;
                          isItemFound = true;
                          break;
                        }
                      }
                      if(isItemFound){
                        print("Item found");
                      }
                      else{
                        masterProvider.addToTrackerList = {
                          "category_id":categoryProduct.id,
                          "product_id":categoryProduct.products[index].id
                        };
                        masterProvider.addToCartItemList = CartItem(count: 1, product: categoryProduct.products[index]);
                        masterProvider.setTotalBySingleValue = categoryProduct.products[index].price;
                      }
                      Navigator.pop(context);

                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)
                  ),
                  color: Colors.green,
                )
              ],
            ),
          ),
        ]
    );

  }
}