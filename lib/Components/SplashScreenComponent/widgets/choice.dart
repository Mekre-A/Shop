import 'package:flutter/material.dart';
import 'package:flutterexamstarter/Components/HomePageComponent/homepage.dart';
import 'package:flutterexamstarter/Provider/MasterProvider.dart';
import 'package:flutterexamstarter/Services/database.dart';
import 'package:flutterexamstarter/Services/http_calls.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Choice extends StatefulWidget{

  @override
  _ChoiceState createState() => _ChoiceState();

  final BuildContext context;
  Choice(this.context);
}


class _ChoiceState extends State<Choice> {
  SqlDatabase sqlDatabase = SqlDatabase();

  @override
  Widget build(BuildContext context) {

    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen: false);
    return Row(
      mainAxisAlignment:MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          child: Text("Try Again"),
          onPressed: () async{
            masterProvider.setShouldSplashScreenReload = true;
            bool status = await HttpCalls.getCategories(masterProvider,widget.context);
            if(status){
              // masterProvider.setShouldSplashScreenReload = false;
              // the above property is set from the http method
            }
            else{
              masterProvider.setShouldSplashScreenReload = false;
              // says opps
            }
          },
        ),
        SizedBox(width: 20,),
        RaisedButton(
          onPressed: ()async{
            masterProvider.setShouldSplashScreenReload = true;
            bool status = await sqlDatabase.loadDataFromDb(masterProvider);
            if(status && masterProvider.getCategories.length != 0){
              masterProvider.setShouldSplashScreenReload = false;
              Navigator.pushReplacement(widget.context, MaterialPageRoute(builder: (context) => HomePage()));

            }
            else{
              if(masterProvider.getCategories.length == 0){
                Fluttertoast.showToast(
                    msg: "Sorry, nothing in the database",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.black,
                    fontSize: 16.0);
              }

              masterProvider.setShouldSplashScreenReload = false;
              // says opps
            }
          },
          child: Text("Load from local Db"),
        ),
      ],
    );
  }
}