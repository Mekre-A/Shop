import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterexamstarter/Models/CartItem.dart';
import 'package:flutterexamstarter/Provider/MasterProvider.dart';
import 'package:provider/provider.dart';

class CartBuilder extends StatefulWidget{

  final List<CartItem> list;

  CartBuilder(this.list);

  @override
  _CartBuilderState createState() => _CartBuilderState();
}

class _CartBuilderState extends State<CartBuilder> {

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen: false);
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait ? 400 : 150,
      width: 350,
      child: ListView.builder(
        itemCount: widget.list.length,
        itemBuilder: ((BuildContext context, int index){
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(

              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        CachedNetworkImage(
                          imageUrl: widget.list[index].getProduct.imageUrl,
                          imageBuilder: ((context, imageProvider){
                            return Container(
                              height: 50,
                              width: 50,
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
                        SizedBox(width: 10,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width:MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width/2 : MediaQuery.of(context).size.width/3,
                              child: Text(
                                widget.list[index].getProduct.name,
                                overflow:TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right:10.0),
                              child: Text("${widget.list[index].getProduct.price} birr",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.grey),),
                            ),

                          ],
                        )
                      ],
                    ),
                    Text("(*${widget.list[index].getCount})",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.add,color: Colors.green,),
                    onPressed: (){
                      widget.list[index].addAmount();
                      masterProvider.setTotalBySingleValue = widget.list[index].getPrice;
                    },
                  ),
                  FlatButton(
                    child: Icon(Icons.remove,color: Colors.red,),
                    onPressed: (){
                      int count = widget.list[index].subtractAmount();
                      masterProvider.setTotalBySingleValue = -widget.list[index].getPrice;
                      if(count == 0){
                        Map toBeRemovedMap;
                        for( Map map in masterProvider.getCartListTracker){
                          if(map['category_id'] == widget.list[index].getProduct.category && map['product_id'] == widget.list[index].getProduct.id){
                            toBeRemovedMap = map;
                            break;
                          }
                        }
                        masterProvider.getCartListTracker.remove(toBeRemovedMap);
                        masterProvider.getCartItemList.removeAt(index);

                        if(masterProvider.getCartItemList.length == 0){
                          masterProvider.setCartListTracker = [];
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ],)
              ],
            ),
          );
        }),
      ),
    );
  }
}