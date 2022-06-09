import 'package:flutter/material.dart';
import 'package:tasks_app/db_query.dart';
import 'package:tasks_app/task_file.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  DateTime? dateTime = null;
  TextEditingController controller = TextEditingController();
  DBQuery dbQuery = DBQuery();
  late Future<List<Task>> myList;

  @override
  void initState() {
    super.initState();
    myList = dbQuery.getAllTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task App'),
      ),
      body: FutureBuilder(
        future: myList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Task>? tasks = snapshot.data as List<Task>?;
            return ListView.builder(
                itemCount: tasks!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(tasks[index].t_name.toString(),
                      style: const TextStyle(fontSize: 20),),
                    subtitle: Text(
                      ' ${tasks[index].time.day}/ ${tasks[index].time.month}/'
                          ' ${tasks[index].time.year}',
                      style: const TextStyle(fontSize: 17),),);
                  }
                  );
          }
          else
            if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
            showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return Container(
                      width: 250,
                      height: 400,
                      margin: EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25))),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(flex: 1, child: Text('Task Name:')),
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    controller: controller,
                                    onSubmitted: (val) {
                                      setState(() {
                                        task = controller.text;
                                        controller.clear();
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(flex: 1, child: Text('Task Date')),
                                Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      child: Text('Pick Date'),
                                      onPressed: () {
                                        showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2022),
                                            lastDate: DateTime(2023))
                                            .then((value) {
                                          setState(() {
                                            dateTime = value;
                                          });
                                        });
                                      },
                                    ))
                              ],
                            ),
                          ),
                          RawMaterialButton(
                              child: const Text('Add Task'),
                              onPressed: () {
                                if (task != null && dateTime != null) {
                                  setState(() {
                                    taskTime time = taskTime(day: dateTime!.day, dayName: dateTime!.day.toString(), month: dateTime!.month,
                                        year: dateTime!.year);

                                    Task t = Task(t_name: task!, time: time);
                                    dbQuery.SaveTask(t);
                                    task = null;
                                    dateTime = null;
                                    myList = dbQuery.getAllTask();
                                  });
                                  Navigator.pop(context);
                                } else {
                                  return;
                                }
                              })
                        ],
                      ));
                });
        },
        child: const Icon(Icons.add),
      ),
    );
  }



}
