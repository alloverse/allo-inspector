#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include <stdlib.h>
#include <stdio.h>

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
