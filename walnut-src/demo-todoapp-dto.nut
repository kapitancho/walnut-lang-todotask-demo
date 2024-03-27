module demo-todoapp-dto %% demo-todoapp-model:

TodoTaskData = [id: String<36>, title: String<1..>, createdAt: DateAndTime, dueDate: Date, isDone: Boolean, description: String];
NewTodoTaskData = [title: String<1..>, dueDate: Date, description: String];

TodoTask ==> TodoTaskData :: [
    id: $.id, title: $.title, createdAt: $.createdAt, dueDate: $.dueDate, isDone: $.isDone->value, description: $.description
];

TaskNotAdded = :[];

ListTodoTasks = ^[:] => Array<TodoTaskData>;
TodoTaskById = ^[~TodoTaskId] => Result<TodoTaskData, UnknownTask>;
AddTodoTask = ^[~NewTodoTaskData] => Result<TaskAdded, TaskNotAdded>;
MarkTaskAsDone = ^[~TodoTaskId] => Result<TaskMarkedAsDone, UnknownTask>;
UnmarkTaskAsDone = ^[~TodoTaskId] => Result<TaskUnmarkedAsDone, UnknownTask>;
RemoveTask = ^[~TodoTaskId] => Result<TaskRemoved, UnknownTask>;
