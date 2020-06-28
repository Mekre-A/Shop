import 'package:flutter/material.dart';
import 'package:flutterexamstarter/Components/SplashScreenComponent/widgets/choice.dart';
import 'package:flutterexamstarter/Provider/MasterProvider.dart';
import 'package:flutterexamstarter/Services/http_calls.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
  MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen: false);
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: Colors.green,
      key: _scaffoldKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Shop",style: TextStyle(fontSize: 40,color: Colors.white),),
            SizedBox(height: 10,),
            FutureProvider<bool>(
              create: (_){
                return HttpCalls.getCategories(masterProvider,_scaffoldKey.currentContext);
              },
              child: Consumer<bool>(
                builder: (_,value,__){
                  if(value == null){
                    return CircularProgressIndicator(
                      backgroundColor: Colors.green,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    );
                  }
                  else if(value){
                    return CircularProgressIndicator(
                      backgroundColor: Colors.green,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    );
                  }
                  else{
                    return Consumer<MasterProvider>(
                      builder: ((context,provider,child){
                        if(provider.getShouldSplashScreenReload){
                          return CircularProgressIndicator(
                            backgroundColor: Colors.green,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          );
                        }
                        else{
                          return Choice(_scaffoldKey.currentContext);
                        }

                      }),
                    );
                  }

                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
