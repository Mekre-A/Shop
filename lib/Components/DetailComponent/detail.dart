
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterexamstarter/Components/DetailComponent/SingleDisplay/single_product_landscape.dart';
import 'package:flutterexamstarter/Components/DetailComponent/SingleDisplay/single_product_portrait.dart';

import 'package:flutterexamstarter/Models/category_product.dart';
import 'package:flutterexamstarter/Provider/MasterProvider.dart';
import 'package:provider/provider.dart';

class Detail extends StatelessWidget{

  final CategoryProduct categoryProduct;
  final int index;

  Detail(this.categoryProduct,this.index);

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("${categoryProduct.name}"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: MediaQuery.of(context).orientation == Orientation.portrait ? SingleProductPortrait(categoryProduct,index) : SingleProductLandscape(categoryProduct,index)
        )
    )
    );

  }
}