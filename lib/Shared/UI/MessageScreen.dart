// ignore_for_file: no_logic_in_create_state,file_names

import 'package:Xpiree/Modules/Dashboard/UI/dashboard.dart';
import 'package:Xpiree/Modules/Document/UI/saved_document.dart';
import 'package:Xpiree/Modules/FolderList/UI/folder_list.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  final String? message;
  final int? screenStatest;
  const MessageScreen({Key? key, this.message, this.screenStatest})
      : super(key: key);

  @override
  MessageScreenState createState() =>
      MessageScreenState(message, screenStatest);
}

class MessageScreenState extends State<MessageScreen> {
  String? message;
  int? screenStatest;
  MessageScreenState(this.message, this.screenStatest);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/success.png',
                ),
              ),
              Text(
                message!,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 50),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    elevation: 0,
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: const Text(
                    "Done",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () {
                    if (screenStatest == 1) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FolderList()),
                      );
                    } else if (screenStatest == 2) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Dashboard(
                                  indexTab: 1,
                                )),
                      );
                    } else if (screenStatest == 3) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SavedDocument()),
                      );
                    } else {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }
}
