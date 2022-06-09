
import 'package:tasks_app/task_file.dart';
import 'package:tasks_app/db_helper.dart';
class DBQuery{
  DBHelper dbHelper = DBHelper();

  // Query to insert into Database
  Future<Task> SaveTask (Task task) async{
    var dbClient = await dbHelper.datebase;
    task.t_id = await dbClient.insert( DBHelper.taskTable, task.toMap());
    print('task has been saved' + '   ${task.t_id}');
    return task;
  }

// Query to get All tasks in the Database
  Future<List<Task>>  getAllTask()async{
    final dbClient= await dbHelper.datebase;

    final List<Map<String, dynamic>> myList = await dbClient.query(DBHelper.taskTable);
    return List.generate(myList.length, (index)
    {
    taskTime time=  taskTime(day:myList[index]['t_day'], dayName:myList[index]['dayName'], month: myList[index]['t_month'],
        year:myList[index] ['t_year']);

    return Task(t_name: myList[index]['t_name'], time: time);
    });
  }



}