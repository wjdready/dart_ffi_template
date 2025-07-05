#pragma once

typedef void (*HttpGetResponse)(const char *);
typedef void (*HttpServeResponse)(const char *);

void http_get(const char *uri, HttpGetResponse response);
void http_serve(HttpServeResponse response);
void native_free(void *ptr);
