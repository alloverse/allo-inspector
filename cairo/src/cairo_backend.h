
#ifndef ___CAIRO_BACKEND
#define ___CAIRO_BACKEND

/// Call to prepare the lib
void imgui_image_init();
/// Call when you are donw with the lib
void imgui_image_deinit();

/// returns pointer to png data. Free it when done. 
char *imgui_image_png_data(int width, int height);

// render to file
void imgui_image_png_file(char *filename, int width, int height);

#endif
