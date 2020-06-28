import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterexamstarter/Components/DetailComponent/detail.dart';
import 'package:flutterexamstarter/Models/CartItem.dart';
import 'package:flutterexamstarter/Models/category_product.dart';
import 'package:flutterexamstarter/Provider/MasterProvider.dart';
import 'package:provider/provider.dart';

class ProductListPortrait extends StatelessWidget{

  final CategoryProduct e;

  ProductListPortrait(this.e);
  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen: false);
    return GridView.builder(
      shrinkWrap: false,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio:1/1.75

      ),
      itemBuilder: ((BuildContext context, int index){
        return Padding(
          padding: const EdgeInsets.symmetric(vertical:4.0,horizontal: 5.0),
          child: Card(
            margin: EdgeInsets.all(0.0),
            elevation: 5.0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  child: CachedNetworkImage(
                    imageUrl: e.products[index].imageUrl,
                    imageBuilder: ((context, imageProvider){
                      return Container(
                        height: 200,
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
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Detail(e,index)));
                  },
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20.0),
                      child: Text(
                        e.products[index].name,
                        maxLines:2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    Text("${e.products[index].price} birr",),
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
                            "category_id":e.id,
                            "product_id":e.products[index].id,

                          };
                          masterProvider.addToCartItemList = CartItem(count: 1, product: e.products[index]);
                          masterProvider.setTotalBySingleValue = e.products[index].price;
                        }
                        else {
                          bool isItemFound = false;
                          for( Map map in masterProvider.getCartListTracker){
                            if(map['category_id'] == e.id && map['product_id'] == e.products[index].id){
                              masterProvider.addCountOfCartItem = map;
                              masterProvider.setTotalBySingleValue = e.products[index].price;
                              isItemFound = true;
                              break;
                            }
                          }
                          if(isItemFound){
                            print("Item found");
                          }
                          else{
                            masterProvider.addToTrackerList = {
                              "category_id":e.id,
                              "product_id":e.products[index].id
                            };
                            masterProvider.addToCartItemList = CartItem(count: 1, product: e.products[index]);
                            masterProvider.setTotalBySingleValue = e.products[index].price;
                          }

                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)
                      ),
                      color: Colors.green,
                    )
                  ],
                ),




              ],
            ),
          ),
        );
      }),
      itemCount: e.products.length,
    );
  }
}