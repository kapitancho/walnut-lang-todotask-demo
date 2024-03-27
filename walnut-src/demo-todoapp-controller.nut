module demo-todoapp-controller %% demo-todoapp-dto:

==> ListTodoTasks %% [~TodoBoard] :: ^[:] => Array<TodoTaskData> ::
    %.todoBoard->allTasks->map(^TodoTask => TodoTaskData :: #->as(type{TodoTaskData}));
==> TodoTaskById %% [~TodoBoard] :: ^[~TodoTaskId] => Result<TodoTaskData, UnknownTask> ::
    %.todoBoard=>taskWithId(#)->as(type{TodoTaskData});
==> AddTodoTask %% [~TodoBoard] :: ^[~NewTodoTaskData] => Result<TaskAdded, TaskNotAdded> :: {
    result = %.todoBoard->addTask(TodoTask(#.newTodoTaskData));
    ?whenTypeOf(result) is {
        type{TaskAdded}: result,
        ~: Error(TaskNotAdded[])
    }
};
==> MarkTaskAsDone %% [~TodoBoard] :: ^[~TodoTaskId] => Result<TaskMarkedAsDone, UnknownTask> ::
    %.todoBoard=>taskWithId(#)->markAsDone;
==> UnmarkTaskAsDone %% [~TodoBoard] :: ^[~TodoTaskId] => Result<TaskUnmarkedAsDone, UnknownTask> ::
    %.todoBoard=>taskWithId(#)->unmarkAsDone;
==> RemoveTask %% [~TodoBoard] :: ^[~TodoTaskId] => Result<TaskRemoved, UnknownTask> ::
    %.todoBoard=>removeTask(#.todoTaskId);

