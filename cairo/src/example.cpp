#include <iostream>
#include <cairo.h>
#include <imgui.h>
#include <imgui_internal.h>
#include "../imgui_software_renderer/src/imgui_sw.hpp"
#include "cairo_backend.h"

void render() {
      // "Draw" a frame
    ImGui::NewFrame();

    ImGui::SetNextWindowSize(ImVec2(200, 200), ImGuiCond_Always);
	ImGui::SetNextWindowPos(ImVec2(0, 0));

    ImGui::Begin("Some Text", nullptr, ImGuiWindowFlags_AlwaysAutoResize | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoMove);
	
	ImGui::SetNextWindowSize(ImVec2(200, 150), ImGuiCond_Always);
	ImGui::SetNextWindowPos(ImVec2(200, 250));
	static float f = 0.0f;
	ImGui::Text("Debug information");
	ImGui::SliderFloat("float", &f, 0.0f, 1.0f);


	ImGui::End();
    ImGui::ShowDemoWindow();
    ImGui::Render();
}

int main() {
    std::cout << "Hello World!" << std::endl;

    // Boilerplate setup
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO();
    
    io.FontGlobalScale = 2;

    // Build atlas
    unsigned char* tex_pixels = NULL;
    int tex_w, tex_h;
    io.Fonts->GetTexDataAsAlpha8(&tex_pixels, &tex_w, &tex_h);

    // Set window size
    io.DisplaySize = ImVec2(1920, 1080);
    io.DeltaTime = 1.0f / 60.0f;

    imgui_sw::bind_imgui_painting();


    io.MousePos = ImVec2(672, 144);
    io.MouseDrawCursor = true;

    render();

    io.MouseDown[0] = true;

    render();

    io.MouseDown[0] = false;

    render();

    imgui_image_png_file("image.png", io.DisplaySize.x, io.DisplaySize.y);

    imgui_sw::unbind_imgui_painting();
    ImGui::DestroyContext();
    
//     // Get the render data
//     auto drawData = ImGui::GetDrawData();

//     cairo_surface_t *texture_surface = cairo_image_surface_create_for_data(tex_pixels, CAIRO_FORMAT_A8, tex_w, tex_h, cairo_format_stride_for_width(CAIRO_FORMAT_A8, tex_w));
//     cairo_t *texture = cairo_create(texture_surface);

//     // Setup cairo surface
//     cairo_surface_t *surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, io.DisplaySize.x, io.DisplaySize.y);
//     cairo_t *cr = cairo_create(surface);

//     cairo_set_line_width(cr, 0.1);


//     std::cout << "Numer of draw lists: " << drawData->CmdListsCount << std::endl;

//     for (int i = 0; i < drawData->CmdListsCount; i++) {
//         auto list = drawData->CmdLists[i];
//         auto idx = list->IdxBuffer;
//         auto vert = list->VtxBuffer;
//         for (int j = 0; j < list->CmdBuffer.size(); j++) {
//             ImDrawCmd cmd = list->CmdBuffer[j];
//             bool moved = false;

//             std::cout << "Drawing " << cmd.ElemCount/3 << " triangles. " << "idx offset: " << cmd.IdxOffset << ", VtxOffset: " << cmd.VtxOffset << ", Texture: " << cmd.TextureId << std::endl;
//             bool hasCallback = cmd.UserCallback != NULL;
//             if (hasCallback) {
//                 std::cout << "  The cmd has a user callback" << std::endl;
//             }
            
//             bool use_pattern = true;
            
            
//             for (unsigned int x = 0; x < cmd.ElemCount; x+=3) {
//                 auto a = vert[cmd.VtxOffset + idx[cmd.IdxOffset + x]];
//                 auto b = vert[cmd.VtxOffset + idx[cmd.IdxOffset + x+1]];
//                 auto c = vert[cmd.VtxOffset + idx[cmd.IdxOffset + x+2]];

//                 if (use_pattern) {
//                     cairo_pattern_t *pattern = cairo_pattern_create_mesh();
//                     cairo_mesh_pattern_begin_patch(pattern);

//                     cairo_mesh_pattern_move_to(pattern, a.pos.x, a.pos.y);
//                     cairo_mesh_pattern_line_to(pattern, b.pos.x, b.pos.y);
//                     cairo_mesh_pattern_line_to(pattern, c.pos.x, c.pos.y);

//                     auto color = ImColor(a.col).Value;
//                     cairo_mesh_pattern_set_corner_color_rgb(pattern, 0, color.x, color.y, color.z);
//                     color = ImColor(b.col).Value;
//                     cairo_mesh_pattern_set_corner_color_rgb(pattern, 1, color.x, color.y, color.z);
//                     color = ImColor(c.col).Value;
//                     cairo_mesh_pattern_set_corner_color_rgb(pattern, 2, color.x, color.y, color.z);

//                     cairo_mesh_pattern_end_patch(pattern);

//                     cairo_pattern_t *mask = cairo_pattern_create_mesh();

//                     cairo_mesh_pattern_begin_patch(mask);
//                     cairo_mesh_pattern_move_to(mask, tex_w * a.uv.x, tex_h * a.uv.y);
//                     cairo_mesh_pattern_line_to(mask, tex_w * b.uv.x, tex_h * b.uv.y);
//                     cairo_mesh_pattern_line_to(mask, tex_w * c.uv.x, tex_h * c.uv.y);
//                     cairo_mesh_pattern_end_patch(mask);

//                     cairo_set_source(cr, pattern);
//                     cairo_mask(cr, mask);
//                     cairo_rectangle(cr, 0, 0, io.DisplaySize.x, io.DisplaySize.y);
//                     cairo_fill(cr);

//                     cairo_pattern_destroy(mask);
//                     cairo_pattern_destroy(pattern);
//                 } else {

//                     cairo_move_to(cr, a.pos.x, a.pos.y);
//                     cairo_line_to(cr, b.pos.x, b.pos.y);
//                     cairo_line_to(cr, c.pos.x, c.pos.y);
//                     cairo_close_path(cr);

//                     auto color = ImColor(a.col).Value;
                    
//                     cairo_set_source_rgb(cr, color.x, color.y, color.z);
                    
//                     cairo_stroke_preserve(cr);
//                     cairo_fill(cr);
//                 }
//             }

//         }
//     }

//     // dump image 
//     cairo_surface_write_to_png(surface, "image.png");

//     // Cleanup
//     cairo_destroy(cr);
//     cairo_surface_destroy(surface);

//     cairo_destroy(texture);
//     cairo_surface_destroy(texture_surface);
//     ImGui::DestroyContext();
//     return 0;
// }


// void draw_image() {
//     cairo_surface_t *surface;
//     cairo_t *cr;

//     surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 390, 60);
//     cr = cairo_create(surface);

//     cairo_set_source_rgb(cr, 0, 0, 0);
//     cairo_select_font_face(cr, "Sans", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
//     cairo_set_font_size(cr, 40.0);

//     cairo_move_to(cr, 10.0, 50.0);
//     cairo_show_text(cr, "Disziplin ist Macht.");

//     cairo_surface_write_to_png(surface, "image.png");

//     cairo_destroy(cr);
//     cairo_surface_destroy(surface);
}
