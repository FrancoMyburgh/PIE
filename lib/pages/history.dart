import 'package:flutter/material.dart';
import 'package:pie/pages/account.dart';
import 'package:pie/pages/home.dart';
import 'package:pie/resources/style_constants.dart';
import 'package:pie/services/networking.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  List<Widget> transactionWidgets = [];

  Future<List> getTransactions() async {

    List transactions = [];

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.getInt('userId').toString();

    NetworkingHelper networkingHelper = NetworkingHelper(urlSuffix: "api/transaction");

    var response = await networkingHelper.getTransactionsFromUserId(userId);

    response.forEach((transaction){
      transactions.add(transaction);
    });

    if(transactions.isEmpty){
      print("Could not load any products");
    }
    return transactions;

  }

  void buildTransactions() async{

    List transactions = await getTransactions();

    if(transactions.isNotEmpty) {
      for (var transaction in transactions) {

        String time = transaction['datePaid'].toString();
        String locationName = transaction['locationName'];

        var amount = double.parse(transaction['amount']);
        String stringAmount = amount.toStringAsFixed(2);

        transactionWidgets.add(
          Container(
            margin: EdgeInsets.only(top: 4.0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: kPieNavy, width: 2, style: BorderStyle.solid)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.directions_car,
                      color: kPiePink,
                      size: 30
                    ),
                    SizedBox(width: 8.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locationName,
                          style: TextStyle(
                            fontFamily: "Poppins ExtraLight",
                            color: kPieNavy,
                          ),
                        ),
                        SizedBox(height: 3.0,),
                        Text(
                          time,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontFamily: "Poppins",
                            color: kPiePurple,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Text(
                  "R$stringAmount",
                  style: TextStyle(
                    color: kPieNavy,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      setState(() {
        transactionWidgets;
      });
    }
  }

  @override
  void initState() {
    buildTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: kPieWhite,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Image.asset("images/PIE Parking Icon.png"),
          ),
          leadingWidth: 50,
          actions: [
            PopupMenuButton(
              child: Icon(
                Icons.menu,
                color: kPiePink,
                size: 40.0,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "home",
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {return HomePage();}));
                  },
                  child: Text("Home"),
                ),
                PopupMenuItem(
                  value: "account",
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {return AccountPage();}));
                  },
                  child: Text("Account"),
                ),
              ],
              onSelected: (String newValue){
                setState((){

                });
              },
            ),
          ],
          shadowColor: Colors.black,
          elevation: 4,
          scrolledUnderElevation: 6,
          backgroundColor: kPieNavy,
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: kPieNavy,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners with a radius of 10
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "History",
                            style: kPieHeadingStyle,
                          ),
                          Column(
                            children: transactionWidgets,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
