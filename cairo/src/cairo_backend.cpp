#include <cairo.h>
#include <imgui.h>
#include <imgui_internal.h>
#include "../imgui_software_renderer/src/imgui_sw.hpp"


/// Call to prepare the lib
void imgui_image_init() {
    imgui_sw::bind_imgui_painting();
}

/// Call when you are donw with the lib
void imgui_image_deinit() {
    imgui_sw::unbind_imgui_painting();
}

class StreamTarget {
    public:
    char *data;
    unsigned int capacity, length;

    StreamTarget() {
        capacity = 1024;
        data = (char*)malloc(capacity);
        length = 0;
    }

    void resize(unsigned int newSize) {
        this->capacity = newSize;
        this->data = (char*)realloc((void*)this->data, this->capacity);
    }
    
    void write(char *data, unsigned int length) {
        if ( this->length + length > this->capacity ) {
            this->resize(this->length + length);
        }
        memcpy(this->data + this->length, data, length);
        this->length += length;
    }

    void normalize() {
        this->resize(this->length);
    }
};

cairo_status_t _cairo_write_stream(void *user, const unsigned char *data, unsigned int length) {
    StreamTarget *target = (StreamTarget *)user;
    target->write((char*)data, length);
    return CAIRO_STATUS_SUCCESS;
}


char *get_data(int width, int height) {        
    char *pixels = (char *)malloc(width * height * 4);
    imgui_sw::paint_imgui((uint32_t*)pixels, width, height);

    // ABGR (imgui) -> RGBA (cairo)
    for (int i = 0; i < width * height * 4; i += 4) {
        unsigned char r = pixels[i];
        unsigned char g = pixels[i+1];
        unsigned char b = pixels[i+2];
        unsigned char a = pixels[i+3];
        pixels[i] = b;
        pixels[i+1] = g;
        pixels[i+2] = r;
        pixels[i+3] = a;
    }
    return pixels;
}

void imgui_image_png_file(char *filename, int width, int height) {
    char *pixels = get_data(width, height);
    cairo_surface_t *surface = cairo_image_surface_create_for_data((unsigned char*)pixels, CAIRO_FORMAT_ARGB32, width, height, cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, width));
    cairo_surface_write_to_png(surface, filename);
    cairo_surface_destroy(surface);
}

char *imgui_image_png_data(int width, int height) {
    char *pixels = get_data(width, height);
    cairo_surface_t *surface = cairo_image_surface_create_for_data((unsigned char*)pixels, CAIRO_FORMAT_ARGB32, width, height, cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, width));

    auto target = StreamTarget();
    cairo_surface_write_to_png_stream(surface, _cairo_write_stream, &target);
    free(pixels);

    target.normalize();
    return target.data;
}
