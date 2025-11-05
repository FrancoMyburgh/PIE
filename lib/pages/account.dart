import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pie/pages/history.dart';
import 'package:pie/pages/home.dart';
import 'package:pie/pages/ticket.dart';
import 'package:pie/resources/style_constants.dart';
import 'package:pie/services/networking.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  String userId = "";
  String firstname = "";
  String lastname = "";
  String username = "";
  String email = "";
  String currentPassword = "";

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();


  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _surnameController = TextEditingController();
  late final TextEditingController _usernameController = TextEditingController();
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();
  late final TextEditingController _repeatPasswordController = TextEditingController();

  bool sessionActive = false;

  void getSessionActive() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      sessionActive = prefs.getBool('sessionActive') ?? false;
    });
  }

  Future<void> getCurrentInfo() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getInt('userId').toString();
    });

    NetworkingHelper networkingHelper = NetworkingHelper(urlSuffix: "api/user");

    var response = await networkingHelper.getDataFromId(userId);

    setState(() {
      firstname = response['firstname'];
      lastname = response['lastname'];
      username = response['username'];
      email = response['email'];
      currentPassword = response["password"];
    });
  }

  void editDetails(String firstname, String lastname, String username, String email, String password) async{

    String hashPassword = "";

    if(password == ""){
      hashPassword = currentPassword;
    }else {
      var bytes = utf8.encode(password);

      // Calculate the SHA256 hash
      var digest = sha256.convert(bytes);

      hashPassword = digest.toString();
    }

    NetworkingHelper networkingHelper = NetworkingHelper(urlSuffix: "api/user");

    var response = await networkingHelper.putAccountData(userId, firstname, lastname, username, email, hashPassword);

    if(response['status'] == 1) {
      showMySnackBar("Success!", Color(0xFF129A0E));
      getCurrentInfo();
    }else{
      showMySnackBar("Oops, please try again", Color(0xFFB30F0F));
    }

  }

  void showMySnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: color,
        ),
      ),
      duration: const Duration(seconds: 3), // Optional: Set duration
      behavior: SnackBarBehavior.floating, // Optional: Set behavior
    );
    snackbarKey.currentState?.showSnackBar(snackBar);
  }


  @override
  void initState() {
    getCurrentInfo().then((_) {
      _nameController.text = firstname;
      _surnameController.text = lastname;
      _usernameController.text = username;
      _emailController.text = email;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: snackbarKey,
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
                    if(sessionActive){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {return TicketPage();}));
                    }else{
                      Navigator.push(context, MaterialPageRoute(builder: (context) {return HomePage();}));
                    }
                  },
                  child: Text("Home"),
                ),
                PopupMenuItem(
                  value: "history",
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {return HistoryPage();}));
                  },
                  child: Text("History"),
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
                          Icon(
                            FontAwesomeIcons.user,
                            color: kPiePurple,
                            size: 60.0,
                          ),
                          Text(
                            "Account",
                            style: kPieHeadingStyle,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Feel free to make changes...",
                                  style: TextStyle(
                                    color: kPiePurple,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8.0),
                                  child: TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      labelText: 'First Name',
                                      hintText: 'e.g., John',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.text,
                                    // The validator receives the text that the user has entered.
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }else if(value.contains(RegExp(r'[^A-z ]'))){
                                        return 'Only letters A to z accepted';
                                      }else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8.0),
                                  child: TextFormField(
                                    controller: _surnameController,
                                    decoration: InputDecoration(
                                      labelText: 'Last Name',
                                      hintText: 'e.g., Doe',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.text,
                                    // The validator receives the text that the user has entered.
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }else if(value.contains(RegExp(r'[^A-z ]'))){
                                        return 'Only letters A to z accepted';
                                      }else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8.0),
                                  child: TextFormField(
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      labelText: 'Username',
                                      hintText: 'e.g., JohnDoe123',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.text,
                                    // The validator receives the text that the user has entered.
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }else if(value.contains(RegExp(r'^([A-z0-9\.-_])$'))){
                                        return 'Invalid username, try another';
                                      }else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8.0),
                                  child: TextFormField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      hintText: 'e.g., john@example.com',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    // The validator receives the text that the user has entered.
                                    validator: (value) {

                                      if (value == null || value.isEmpty) {
                                        return 'Please enter an email address';
                                      }else if(!RegExp(r'^([A-z0-9]+)(@)([A-z]+)(\.)([A-z\.]+)$').hasMatch(value)){
                                        return 'Invalid email address';
                                      }else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8.0),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      labelText: 'Create a password',
                                      hintText: 'P@ssw0rd',
                                      border: OutlineInputBorder(),
                                    ),
                                    obscureText: true,
                                    keyboardType: TextInputType.visiblePassword,
                                    // The validator receives the text that the user has entered.
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return null;
                                      }else{
                                        if(!RegExp(r'(?=.*[!@#$%^&*])(?=.*[0-9])(?=.*[A-Z])[A-z0-9!@#$%^&*]{8,}$').hasMatch(value)) {
                                          return 'Use capitals, numbers & symbols';
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8.0),
                                  child: TextFormField(
                                    controller: _repeatPasswordController,
                                    decoration: InputDecoration(
                                      labelText: 'Repeat password',
                                      border: OutlineInputBorder(),
                                    ),
                                    obscureText: true,
                                    keyboardType: TextInputType.visiblePassword,
                                    // The validator receives the text that the user has entered.
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return null;
                                      }else{
                                        if(value != _passwordController.text) {
                                          return 'Passwords do not match';
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8.0),
                                  child: ElevatedButton(
                                    style: kPieElevatedButtonStyle,
                                    onPressed: () {
                                      // Validate returns true if the form is valid, or false otherwise.
                                      if (_formKey.currentState!.validate()) {
                                        editDetails(
                                            _nameController.text,
                                            _surnameController.text,
                                            _usernameController.text,
                                            _emailController.text,
                                            _passwordController.text
                                        );
                                      }
                                    },
                                    child: const Text('Confirm Changes'),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
