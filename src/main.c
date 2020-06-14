#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>

#define PATH_MAX 1024
#ifdef WIN32
#include <Windows.h>
static char* here() {
    WCHAR path[PATH_MAX];
    GetModuleFileNameW(NULL, path, PATH_MAX);
    PathCchRemoveFileSpec(path, PATH_MAX);
    char* output = (char*)malloc(PATH_MAX);
    sprintf(output, "%ws", path);
    return output;
}
#elif defined(DARWIN)
#include <libproc.h>
static char* here() {
    char pathbuf[PROC_PIDPATHINFO_MAXSIZE];
    pid_t  pid = getpid();
    int ret = proc_pidpath(pid, pathbuf, sizeof(pathbuf));
    assert(ret > 0);
    const char* dir = dirname(result);
    return strdup(pathbuf);
}
#else
#include <libgen.h>
static char* here() {
    char result[PATH_MAX];
    ssize_t count = readlink("/proc/self/exe", result, PATH_MAX);
    const char* path;
    if (count != -1) {
        path = dirname(result);
    }
    return strdup(path);
}
#endif

int main(int argc, char** argv)
{
  lua_State* L = luaL_newstate();
  luaL_openlibs(L);

  if (luaL_dofile(L, "lua/main.lua") == 0)
  {
    return 0;
  }
  else
  {
    const char *err = luaL_checkstring(L, -1);
    printf("Failed to run main.lua: %s\n", err);
    return 1;
  }
}
