module demo-todoapp-http %% http-core, http-route, http-response-helper, demo-todoapp-controller:

TodoTaskHttpRouteChain = HttpRouteChain;

==> TodoTaskHttpRouteChain ::
    HttpRouteChain[routes: [
        httpPost            [RoutePattern('/tasks/{todoTaskId}/done'), type{MarkTaskAsDone}],
        httpDelete          [RoutePattern('/tasks/{todoTaskId}/done'), type{UnmarkTaskAsDone}],
        httpDelete          [RoutePattern('/tasks/{todoTaskId}'), type{RemoveTask}],
        httpGetAsJson       [RoutePattern('/tasks/{todoTaskId}'), type{TodoTaskById}],
        httpPostJsonLocation[RoutePattern('/tasks'), type{AddTodoTask}, 'newTodoTaskData'],
        httpGetAsJson       [RoutePattern('/tasks'), type{ListTodoTasks}]
    ]];

TodoTaskHttpHandler = :[];
TodoTaskHttpHandler ==> HttpRequestHandler %% [~TodoTaskHttpRouteChain] :: {
    todoTaskHttpRouteChain = %.todoTaskHttpRouteChain;
    ^[request: HttpRequest] => Result<HttpResponse, Any> :: {
        request = #.request;
        response = ?whenTypeOf(todoTaskHttpRouteChain) is {
            type{HttpRouteChain}: todoTaskHttpRouteChain->handleRequest(request),
            ~: null
        };
        ?whenTypeOf(response) is {
            type{Result<Nothing, HttpRouteDoesNotMatch>}: notFound(request),
            type{HttpResponse}: response,
            ~: {
                [
                    statusCode: 200,
                    protocolVersion: HttpProtocolVersion.HTTP11,
                    headers: [:],
                    body: 'oops'
                ]
            }
        }
    }
};

InvalidJsonString ==> HttpResponse :: badRequest({'Invalid JSON body: '}->concat($->value));
HydrationError ==> HttpResponse :: badRequest({'Invalid request parameters: '}->concat($->errorMessage));
DependencyContainerError ==> HttpResponse :: internalServerError({'Handler error: '}->concatList[
    $->errorMessage, ': ', $->targetType->asString
]);
InvalidJsonValue ==> HttpResponse :: internalServerError({'Invalid handler result: '}->concat($.value->type->asString));
CastNotAvailable ==> HttpResponse :: internalServerError(''->concatList[
    'Type conversion failure: from type ', $.from->asString, ' to type ', $.to->asString
]);

UnknownTask ==> HttpResponse :: notFound({'Unknown task with id '}->concat($.todoTaskId));

TaskAdded ==> String :: '/playroom/tables/'->concat($.task->id);
TaskNotAdded ==> HttpResponse :: internalServerError('Task not added');
