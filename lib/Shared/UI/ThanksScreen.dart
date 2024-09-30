
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:Xpiree/Modules/Auth/UI/login.dart';

class ThanksScreen extends StatelessWidget {
  const ThanksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background-building.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Center(child: Image.asset('assets/images/ucp-logo.png')),
              const Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Text('Thank You!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
              ),
              const Text(
                'For Providing the information about yourself. Your information is being reviewed by ICT Administration. We will inform you once your account is approved.',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF002a50)),
                textAlign: TextAlign.justify,
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                 
                 
                  style: ElevatedButton.styleFrom(
                     /* textColor: Theme.of(context).textTheme.headline1!.color, */
                     shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11)),
                  padding: const EdgeInsets.all(0.0),

                  ),
                  child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 7,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                  ),
                  onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
                  },
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
