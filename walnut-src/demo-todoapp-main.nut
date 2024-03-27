module demo-todoapp-main %% demo-todoapp-model, http-core, http-route, http-response-helper, generic-http, demo-todoapp-config:

handleRequest = ^HttpRequest => HttpResponse :: {
    response = HttpServer[]->handleRequest(#);
    ?whenTypeOf(response) is {
        type{HttpResponse}: response,
        ~: [
           statusCode: 500,
           protocolVersion: HttpProtocolVersion.HTTP11,
           headers: [:],
           body: ''
       ]
    }
};

main = ^Array<String> => String :: {
    x = 'Compilation successful!';
    x->printed
};