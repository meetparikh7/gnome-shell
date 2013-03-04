/*
 * st-scroll-view-fade.glsl: Edge fade effect for StScrollView
 *
 * Copyright 2010 Intel Corporation.
 * Copyright 2011 Adel Gadllah
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU Lesser General Public License,
 * version 2.1, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
 * more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

uniform sampler2D tex;
uniform float height;
uniform float width;
uniform float vfade_offset;
uniform float hfade_offset;
uniform float vvalue;
uniform float hvalue;

/*
 * Used to pass the fade area to the shader
 *
 * [0][0] = x1
 * [0][1] = y1
 * [1][0] = x2
 * [1][1] = y2
 *
 */
uniform mat2 fade_area;

/*
 * Scale from [0.0, 1.0] to [1.0, 1.0]. Do this by
 * changing it to scaling [1.0, 0.0] to [0.0, 0.0]
 * and then transforming the end result.
 */
#define FADE(gradient, factor) (1.0 - (1.0 - gradient) * factor)

void main ()
{
    cogl_color_out = cogl_color_in * texture2D (tex, vec2 (cogl_tex_coord_in[0].xy));

    float y = height * cogl_tex_coord_in[0].y;
    float x = width * cogl_tex_coord_in[0].x;

    if (x < fade_area[0][0] || x > fade_area[1][0] ||
        y < fade_area[0][1] || y > fade_area[1][1])
        return;

    float ratio = 1.0;
    float fade_bottom_start = fade_area[1][1] - vfade_offset;
    float fade_right_start = fade_area[1][0] - hfade_offset;
    bool fade_top = y < vfade_offset && vvalue > 0.0;
    bool fade_bottom = y > fade_bottom_start && vvalue < 1.0;
    bool fade_left = x < hfade_offset && hvalue > 0.0;
    bool fade_right = x > fade_right_start && hvalue < 1.0;

    float vfade_scale = height / vfade_offset;
    if (fade_top) {
        ratio *= FADE((y / vfade_offset), min(sqrt(vvalue) * vfade_scale, 1.0));
    }

    if (fade_bottom) {
        ratio *= FADE((fade_area[1][1] - y)/(fade_area[1][1] - fade_bottom_start), min(sqrt(1.0 - vvalue) * vfade_scale, 1.0));
    }

    float hfade_scale = width / hfade_offset;
    if (fade_left) {
        ratio *= FADE(x / hfade_offset, min(sqrt(hvalue) * hfade_scale, 1.0));
    }

    if (fade_right) {
        ratio *= FADE((fade_area[1][0] - x)/(fade_area[1][0] - fade_right_start), min(sqrt(1.0 - hvalue) * hfade_scale, 1.0));
    }

    cogl_color_out *= ratio;
}