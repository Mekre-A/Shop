


import 'package:flutter/material.dart';
import 'package:flutterexamstarter/Components/HomePageComponent/widgets/ListOfProduct/list_products_landscape.dart';
import 'package:flutterexamstarter/Components/HomePageComponent/widgets/ListOfProduct/list_products_portrait.dart';
import 'package:flutterexamstarter/Components/HomePageComponent/widgets/list_item.dart';
import 'package:flutterexamstarter/Provider/MasterProvider.dart';
import 'package:flutterexamstarter/Services/method_channel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen:false);
    return DefaultTabController(
      length: masterProvider.getCategories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Shop'),
          centerTitle: true,
          bottom: TabBar(
            tabs:
              masterProvider.getCategories.map((e) =>
              Tab(text: e.name,)
              ).toList()
            ,
            isScrollable: true,
          ),

          actions: <Widget>[


        Builder(builder: (context) => IconButton(icon:
                Icon(Icons.shopping_cart),

            onPressed: (){
              if(masterProvider.getCartListTracker.length == 0){
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("There are no items in the cart"),
                  duration: Duration(seconds: 2),
                ));
                return;
              }
              showDialog(context: context,child:
              SimpleDialog(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Shopping Cart",style: TextStyle(fontSize: 24),),
                  ),
                  Consumer<MasterProvider>(builder: ((context,provider,child){
                    return CartBuilder(provider.getCartItemList);
                  }),),
                  Center(child: Consumer<MasterProvider>(builder: ((context,provider,child){
                    return Text("Total: ${provider.getTotal} Birr",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18),);
                  }),)),
                  RaisedButton(
                    child:Text("Checkout",style: TextStyle(color: Colors.white),),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)
                    ),
                    color: Colors.green,
                    onPressed: (){
                      masterProvider.setCartItems = [];
                      masterProvider.setCartListTracker = [];
                      masterProvider.setTotal = 0.0;
                      MethodChannelNotification.notify();
                      Navigator.pop(context);
                    },
                  )



                ],
              ));

            },
            )),

            SizedBox(width: 5,),

            Center(
              child: Padding(
                padding: const EdgeInsets.only(right:10.0),
                child: Consumer<MasterProvider>(
                  builder: ((context,provider,child){
                    return Text("${provider.getCartListTracker.length}", style: TextStyle(fontSize: 18),);
                  }),

                ),
              ),
            )
          ],
        ),
        body: TabBarView(
          children: masterProvider.getCategoryProducts.map((e){
            if(MediaQuery.of(context).orientation == Orientation.portrait){
              return ProductListPortrait(e);
            }
            else{
              return ProductListLandscape(e);
            }

          }).toList(),
        ),
      ),
    );
  }
}

