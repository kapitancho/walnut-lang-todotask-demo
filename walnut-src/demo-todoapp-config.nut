module demo-todoapp-config %% demo-todoapp-model, demo-todoapp-http, http-middleware:

==> LookupRouterMapping :: [
    [path: '/v1', type: type{TodoTaskHttpHandler}]
];

==> CompositeHandler %% [
    defaultHandler: NotFoundHandler,
    ~LookupRouter,
    ~CorsMiddleware
] :: CompositeHandler[
    defaultHandler: %.defaultHandler->as(type{HttpRequestHandler}),
    middlewares: [
        %.corsMiddleware->as(type{HttpMiddleware}),
        %.lookupRouter->as(type{HttpMiddleware})
    ]
];

==> TodoBoardDataSource @ InvalidDate :: {
    task1 = TodoTask[title: 'Task 1', dueDate: ?noError(Date[2024, 6, 30]), description: 'This is the first task'];
    [:]->withKeyValue[key: task1->id, value: task1]
};
