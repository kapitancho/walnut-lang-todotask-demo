module demo-todoapp-model %% datetime:

TaskMarkedAsDone = :[];
TaskUnmarkedAsDone = :[];

TodoTaskId = String<36>;
TodoTask = $[id: TodoTaskId, title: String<1..>, isDone: Mutable<Boolean>, dueDate: Date, createdAt: DateAndTime, description: String];
TodoTask[title: String<1..>, dueDate: Date, description: String] %% [~Clock, ~Random] :: [
    id: %.random->uuid,
    title: #.title,
    isDone: Mutable[type{Boolean}, false],
    dueDate: #.dueDate,
    createdAt: %.clock->now,
    description: #.description
];
TodoTask->id(^Null => TodoTaskId) :: $.id;
TodoTask->markAsDone(^Null => TaskMarkedAsDone) :: {$.isDone->SET(true); TaskMarkedAsDone[]};
TodoTask->unmarkAsDone(^Null => TaskUnmarkedAsDone) :: {$.isDone->SET(false); TaskUnmarkedAsDone[]};

TodoTask ==> JsonValue :: [
    id: $.id,
    title: $.title,
    isDone: $.isDone->value,
    dueDate: $.dueDate,
    createdAt: $.createdAt,
    description: $.description
];

TodoBoardDataSource = Map<TodoTask>;

UnknownTask = $[~TodoTaskId];
TaskAlreadyExists = $[~TodoTaskId];
TaskAdded = $[task: TodoTask];
TaskRemoved = $[task: TodoTask];

TodoBoard = $[tasks: Mutable<Map<TodoTask>>];
TodoBoard(Null) %% TodoBoardDataSource :: [tasks: Mutable[type{Map<TodoTask>}, %]];
TodoBoard->addTask(^TodoTask => Result<TaskAdded, TaskAlreadyExists>) :: ?whenIsTrue {
    $.tasks->value->keyExists(#->id): Error(TaskAlreadyExists[#->id]),
    ~: {
        $.tasks->SET($.tasks->value->withKeyValue[key: #->id, value: #]);
        TaskAdded[task: #]
    }
};
TodoBoard->removeTask(^TodoTaskId => Result<TaskRemoved, UnknownTask>) :: {
    x = $.tasks->value->withoutByKey(#);
    ?whenTypeOf(x) is {
        type[map: Map<TodoTask>, element: TodoTask]: {
            $.tasks->SET(x.map);
            TaskRemoved[task: x.element]
        },
        ~: Error(UnknownTask[#])
    }
};
TodoBoard->taskWithId(^[~TodoTaskId] => Result<TodoTask, UnknownTask>) :: {
    task = $.tasks->value->item(#.todoTaskId);
    ?whenTypeOf(task) is {
        type{TodoTask}: task,
        ~: Error(UnknownTask(#))
    }
};
TodoBoard->allTasks(^Null => Array<TodoTask>) :: $.tasks->value->values;

TodoBoard ==> JsonValue @ InvalidJsonValue :: $.tasks->value => asJsonValue;
