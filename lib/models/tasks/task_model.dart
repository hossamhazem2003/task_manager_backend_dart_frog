class TaskModel {
  TaskModel({
    required this.itemId,
    required this.taskId,
    required this.taskDescription,
    required this.createdAt,
    required this.isDone,
    required this.numOfHours,
  });

  final String itemId;
  final String taskId;
  final String taskDescription;
  final String createdAt;
  final bool isDone;
  final int numOfHours;


  // Convert a TaskModel object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'taskId': taskId,
      'taskDescription': taskDescription,
      'createdAt': createdAt,
      'isDone': isDone,
      'numOfHours': numOfHours,
    };
  }
}
