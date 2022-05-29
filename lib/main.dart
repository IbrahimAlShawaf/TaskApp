
import 'package:flutter/material.dart';
import 'package:tasks_app/task_file.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String? task;
  DateTime? dateTime= null;
  List<Task> myTask=[];

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task App'),
      ),
      body:myTask.isEmpty?Center(child: Text('No Tasks are added yet!',style: TextStyle(fontSize: 22),),):
      ListView(
        children: myTask.map((tsk){
          return ListTile(
            title: Text("${tsk.taskName}"),
            subtitle: Text("${tsk.taskDate}"),
          );
        } ).toList(),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showModalBottomSheet(context: context,
              backgroundColor: Colors.transparent,
              builder: (context){
            return Container(

                width: 250,
                height: 400,
              margin: EdgeInsets.only(left: 8,right:8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)
                    )
                ),
              child: Column(
                children: [
                 Container(
                   margin: EdgeInsets.all(16),
                   child: Row(
                     children: [
                       Expanded(flex: 1,child: Text('Task Name:')),
                       Expanded(flex: 1,child: TextField(
                         controller: controller,
                         onSubmitted: (val){
                           setState(() {
                             task = controller.text;
                             controller.clear();
                           });
                         },
                       ),)
                     ],
                   ),
                 ),
                  Container(
                    margin: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(flex: 1,child: Text('Task Date')),
                        Expanded(flex: 1,child: ElevatedButton(
                          child: Text('Pick Date'),
                          onPressed: (){
                            showDatePicker(context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2023)).then((value) {
                                  setState(() {
                                    dateTime = value;
                                  });
                            });
                          },
                        )
                        )
                      ],
                    ),
                  ),
                  RawMaterialButton(
                      child: Text('Add Task'),
                      onPressed: (){
                        if(task!=null && dateTime!=null)
                          {
                            setState(() {
                              myTask.add(Task(taskName: task!,taskDate: dateTime!));
                              task= null;
                              dateTime=null;
                            });
                            Navigator.pop(context);
                          }
                        else{
                          return;
                        }

                      })
                ],
              )
            );
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }


}
