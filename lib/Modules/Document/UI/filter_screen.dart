import 'package:Xpiree/Modules/Dashboard/UI/dashboard.dart';
import 'package:Xpiree/Modules/Document/UI/filter_document.dart';
import 'package:Xpiree/Shared/Model/shared_model.dart';
import 'package:Xpiree/Shared/Utils/ddlLists.dart';
import 'package:flutter/material.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Xpiree/Modules/Document/Model/DocumentModel.dart';
import 'package:Xpiree/Modules/Document/Utils/DocumentDataHelper.dart';
import 'package:Xpiree/Modules/Dashboard/UI/NavigationBottom.dart';
import 'package:Xpiree/Modules/FolderList/Model/FolderModel.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  FilterScreenState createState() => FilterScreenState();
}

class FilterScreenState extends State<FilterScreen> {
  
  final _formKey = GlobalKey<FormState>();
List<TblDocType> listofDocType=[];
List<TblFolder> listofFolders=[];

  FilterDocVm modal=FilterDocVm();
List<String> strFolder = [];
List<String> strDocType = [];

  @override
  void initState() {
    super.initState();

        EasyLoading.addStatusCallback((status) {});
      EasyLoading.show(status: 'loading...');
        fetchDocType(null).then((response){
          setState(() {
              listofDocType=response!;
           
          });
          EasyLoading.dismiss();
        }); 
        fetchUserFolders(null).then((response){
          setState(() {
              listofFolders=response!;
           
          });
          EasyLoading.dismiss();
        });
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
        child: Container(
        padding: const EdgeInsets.all(15),
        
        child:  Form(
            key: _formKey,
            child: ListView(
          
          children:[
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,

               children:[
               
                 IconButton(
                  onPressed: (){
                     Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) =>   Dashboard(indexTab: 1)),
                       );
                  }, 
                  icon: Icon(Icons.close,color: Theme.of(context).colorScheme.blackColor)
                  ),

                  const Text(
                 "Filter",
                 textAlign: TextAlign.left,
                 style: CustomTextStyle.topHeading,
                 ),
                  InkWell(
                   child:Text("Clear All",
                   style: Theme.of(context).textTheme.bodyText2,
                   ),
                   onTap: ()
                   {
                     setState(() {
                         strFolder = [];
                         strDocType = [];
                         modal.docFolderList=[];
                         modal.docTypeList=[];
                         modal.docOrdering=0;
                         modal.reminder=false;
                         modal.taskAssociated=false; 
                       
                     });
               
                      
                   },
                 )



               ]
              

             ),
            Container(
               padding: const EdgeInsets.fromLTRB(5,25,5,5),
               child: 
                   Text("Sort by Document Name",style: Theme.of(context).textTheme.bodyText2),
                
              ),
              Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                     children: [
                       Radio(
                          value: 1,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          activeColor: Theme.of(context).colorScheme.linkTextColor,
                          groupValue:  modal.docOrdering,
                          onChanged: (value){
                                 setState(() {
                                  modal.docOrdering = value as int;
                               });

                           },
                         ),
                          Text("A to Z",style: Theme.of(context).textTheme.headline6),
                     ],
                   ),
                   Row(
                       children: [
                         Radio(
                            value: 2,
                            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                            activeColor: Theme.of(context).colorScheme.linkTextColor,
                           groupValue:  modal.docOrdering,
                           onChanged: (value){
                                 setState(() {
                                  modal.docOrdering = value as int;
                               });

                           },
                         ),
                         Text("Z to A",style: Theme.of(context).textTheme.headline6),
                       ],
                     ),
                     
                
                ],
              ),
               Divider(
                      color: Theme.of(context).colorScheme.iconThemeGray,
                      height: 30,
                      thickness: 1,
                    ),
            Container(
               padding: const EdgeInsets.fromLTRB(5,5,5,5),
               child:   Text("View by Document Type",style: Theme.of(context).textTheme.bodyText2)
                 ),

                 Wrap(
                      children:  listofDocType.map((list) => 
                      InkWell(
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border:Border.all(color: list.isChecked==null|| list.isChecked==false? Theme.of(context).colorScheme.iconThemeGray:Theme.of(context).colorScheme.linkTextColor,)
                          
                        ),
                          child: Text(list.title,style: TextStyle(fontSize: 14,color: list.isChecked==null|| list.isChecked==false? Theme.of(context).colorScheme.iconThemeGray:Theme.of(context).colorScheme.linkTextColor)),

                        ),
                          onTap: (){
                            setState(() {
                            
                            if(list.isChecked==true)
                            {
                              list.isChecked=false;
                                

                            }
                            else{
                              list.isChecked=true;
                              strDocType.add(list.id);

                            }
                            });
                        
                          },
                      )
                          ) .toList(),),
              Divider(
                  color: Theme.of(context).colorScheme.iconThemeGray,
                  height: 30,
                  thickness: 1,
                ),
                  
                
                              
             Container(
                   padding: const EdgeInsets.fromLTRB(5,5,5,5),
               child:   Text("View by Document Folder",style: Theme.of(context).textTheme.bodyText2)
              ),
              
               Wrap(
                          children:  listofFolders.map((list) => 
                               InkWell(
                                child: Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(10),
                               decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                             border:Border.all(color: list.isChecked==null|| list.isChecked==false? Theme.of(context).colorScheme.iconThemeGray:Theme.of(context).colorScheme.linkTextColor,)
                          
                            ),
                               child: Text(list.name,style: TextStyle(fontSize: 14,color: list.isChecked==null|| list.isChecked==false? Theme.of(context).colorScheme.iconThemeGray:Theme.of(context).colorScheme.linkTextColor)),


                            ),
                            onTap: ()
                            {
                              setState(() {
                                if(list.isChecked==true)
                                {
                                  list.isChecked=false;
                                }
                                else
                                {
                                  list.isChecked=true;
                                  strFolder.add(list.id);

                                }
                                
                              
                              });
                              

                            },)
                             ).toList(),),
               Divider(
                      color: Theme.of(context).colorScheme.iconThemeGray,
                     height: 30,
                      thickness: 1,
                    ),
                 Container(
                   padding: const EdgeInsets.fromLTRB(5,5,5,5),
               child:   Text("View by Reminder",style: Theme.of(context).textTheme.bodyText2)
              ),

              Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio(
                              value: true,
                              activeColor: Theme.of(context).colorScheme.linkTextColor,
                            groupValue:  modal.reminder,
                             visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                            onChanged: (value){
                                  setState(() {
                                   modal.reminder = value as bool;
                                });

                            },
                          ),
                           Text("Reminder On",style: Theme.of(context).textTheme.headline6),
                      ],
                    ),
                    Row(
                        children: [
                          Radio(
                              value: false,
                              activeColor: Theme.of(context).colorScheme.linkTextColor,
                              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                              groupValue:  modal.reminder,
                              onChanged: (value){
                                  setState(() {
                                   modal.reminder = value as bool;
                                });

                            },
                          ),
                          Text("Reminder Off",style: Theme.of(context).textTheme.headline6),
                        ],
                      ),
                      
                  ],
                ),
              ),
               Divider(
                      color: Theme.of(context).colorScheme.iconThemeGray,
                      height: 30,
                      thickness: 1,
                    ),
                Container(
                   padding: const EdgeInsets.fromLTRB(5,5,5,5),
               child:   Text("View by Task",style: Theme.of(context).textTheme.bodyText2)
              ),
                Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Row(
                      children: [
                        Radio(
                              value: true,
                             visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                            activeColor: Theme.of(context).colorScheme.linkTextColor,
                            groupValue:  modal.taskAssociated,
                            onChanged: (value){
                                  setState(() {
                                   modal.taskAssociated = value as bool;
                                });

                            },
                          ),
                           Text("Associated with Tasks",style: Theme.of(context).textTheme.headline6),
                      ],
                    ),
                    Row(
                        children: [
                          Radio(
                            value: false,
                            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                            activeColor: Theme.of(context).colorScheme.linkTextColor,
                            groupValue:  modal.taskAssociated,
                            onChanged: (value){
                                  setState(() {
                                   modal.taskAssociated = value as bool;
                                });

                            },
                          ),
                          Text("No Tasks",style: Theme.of(context).textTheme.headline6),
                        ],
                      ),
                      
                  ],
                ),
              ),


          ]
        ),
            
            )
        
        
      ),
      ), 
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
          width: 150,
          child: FloatingActionButton.extended(
          onPressed: () {  
            EasyLoading.addStatusCallback((status) {});
            EasyLoading.show(status: 'loading...');
          
             getFilterDocuments(modal,strFolder,strDocType).then((response)
             {
              EasyLoading.dismiss();
                Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => FilterDocument(listdata:response)),
                        );  

             });
          },
          label:  Text('Apply', style: Theme.of(context).textTheme.headline3,),
          backgroundColor: Theme.of(context).primaryColor,
      ),
        )  
     );
  }
}
