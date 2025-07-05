#include "export.h"
#include <atomic>
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <thread>

#define printWithFlush(...)                                                                                            \
    printf(__VA_ARGS__);                                                                                               \
    fflush(stdout);

void http_get(const char *uri, void (*onResponse)(const char *))
{
    std::thread([onResponse]() {
        std::this_thread::sleep_for(std::chrono::seconds(3));
        printWithFlush("c: onResponse\n");

        char *response = (char *)malloc(100);
        snprintf(response, 100, "Hello World %d", 123);
        onResponse(response);

        printWithFlush("c: onResponse done, bye\n");
    }).detach();
}

void http_serve(void (*onRequest)(const char *))
{
    std::thread([onRequest]() {
        while (true)
        {
            std::this_thread::sleep_for(std::chrono::seconds(1));
            char *response = (char *)malloc(100);
            snprintf(response, 100, "Hello World ok %d", 123);
            onRequest(response);
        }
    }).detach();
}

void native_free(void *ptr)
{
    free(ptr);
}
