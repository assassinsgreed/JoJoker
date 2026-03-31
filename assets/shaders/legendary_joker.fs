#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define PRECISION highp
#else
	#define PRECISION mediump
#endif

#define M_PI 3.1415926535897932384626433832795

// Look ionized.fs for explanation
extern PRECISION vec2 legendary_joker;

extern PRECISION number dissolve;
extern PRECISION number time;
// (sprite_pos_x, sprite_pos_y, sprite_width, sprite_height) [not normalized]
extern PRECISION vec4 texture_details;
// (width, height) for atlas texture [not normalized]
extern PRECISION vec2 image_details;
extern bool shadow;
extern PRECISION vec4 burn_colour_1;
extern PRECISION vec4 burn_colour_2;

// [Util]
// Transform color from HSL to RGB
vec4 RGB(vec4 c);

// [Util]
// Transform color from RGB to HSL
vec4 HSL(vec4 c);

// [Required]
// Apply dissolve effect (when card is being "burnt", e.g. when consumable is used)
vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv);

float stackoverflow_hash(number value, number index)
{
    return fract(sin(dot(vec2(index/value, value/index), vec2(12.9898,78.233))) * 43758.5453);
}

number logisticCurve(number x)
{
    return 1.0 / (1.0 + exp(6.0-8.0*x)) - 0.005;
}

number hideFormula(number x)
{
    return 1.0 - pow(sin(M_PI/2.0 * x),20.0);
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    // 1. NORMALIZED UV CALCULATION
    // This explicitly maps the effect to the 0.0-1.0 range of the SPECIFIC sprite.
    // This fixes the "empty top 15%" and the "black box" issues.
    vec4 tex = Texel(texture, texture_coords);
    vec2 uv = (texture_coords * image_details.xy - texture_details.xy) / texture_details.ba;

    // 2. Glacial Timing (Slowing down the shimmer and the dots)
    float shimmer_time = time * 0.03 + legendary_joker.g * 5.0;
    float dot_time     = time * 0.04 + legendary_joker.g * 10.0;
    float tilt         = (legendary_joker.r - 0.5) * 1.5; 

    // 3. The Rainbow Shimmer
    float rainbow_uv = uv.x + uv.y * tilt + sin(shimmer_time) * 0.2;
    float hue_cycle = fract(rainbow_uv * 0.3 + shimmer_time * 0.08);
    vec3 rainbow_color = RGB(vec4(hue_cycle, 0.8, 0.8, 1.0)).rgb;
    
    float shimmer_band = smoothstep(0.2, 0.8, sin(rainbow_uv * 1.5 + shimmer_time));
    vec3 final_shimmer = rainbow_color * (0.2 + 0.5 * shimmer_band);

    // 4. Random Speckle Dots (Fully Jittered)
    // Grid scale 6.0 gives a good balance of "hero" speckles and fine glitter
    vec2 dot_uv = uv * 6.0; 
    vec2 grid_id = floor(dot_uv);
    
    // Create unique hashes for every cell
    float h1 = stackoverflow_hash(grid_id.x + legendary_joker.g, grid_id.y + 7.0);
    float h2 = stackoverflow_hash(grid_id.y, grid_id.x + 13.37);
    
    float dot_out = 0.0;

    // Threshold for premium sparsity (~35% density)
    if (h1 > 0.65) {
        // PLACEMENT: Heavy jitter to break the grid feel
        vec2 jitter = vec2(h1 - 0.5, h2 - 0.5) * 0.8;
        vec2 grid_fract = fract(dot_uv) - 0.5 - jitter;

        // SIZE: Various sizes from tiny pinpricks to bold orbs
        float dot_size = 0.02 + (h1 * 0.08); 
        
        // SPEED & FADE: De-synced "breathing" animation
        float individual_speed = 0.5 + (h2 * 1.0);
        float blink = smoothstep(0.1, 0.9, sin(dot_time * individual_speed + h1 * 6.28));
        
        float dist = length(grid_fract);
        
        // Create a soft glowing orb
        float core = dot_size / max(0.001, dist);
        dot_out = core * 0.22 * blink;
        dot_out += (0.012 / max(0.001, dist)) * blink; // Center "hot" spot
        
        // Soft-clip to keep the dot naturally contained
        dot_out *= smoothstep(0.6, 0.1, dist);
    }

    // 5. High-Impact Blending
    float card_lum = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
    vec3 holo_layer = final_shimmer + (vec3(dot_out) * rainbow_color);

    // Additive mix with high intensity for that "Legendary" pop
    vec3 final_rgb = tex.rgb + (holo_layer * (card_lum + 0.6) * 1.2);
    tex.rgb = mix(tex.rgb, final_rgb, 0.95);

    // 6. Return with the corrected UV
    return dissolve_mask(tex * colour, texture_coords, uv);
}

number hue(number s, number t, number h)
{
	number hs = mod(h, 1.)*6.;
	if (hs < 1.) return (t-s) * hs + s;
	if (hs < 3.) return t;
	if (hs < 4.) return (t-s) * (4.-hs) + s;
	return s;
}

vec4 RGB(vec4 c)
{
	if (c.y < 0.0001)
		return vec4(vec3(c.z), c.a);

	number t = (c.z < .5) ? c.y*c.z + c.z : -c.y*c.z + (c.y+c.z);
	number s = 2.0 * c.z - t;
	return vec4(hue(s,t,c.x + 1./3.), hue(s,t,c.x), hue(s,t,c.x - 1./3.), c.w);
}

vec4 HSL(vec4 c)
{
	number low = min(c.r, min(c.g, c.b));
	number high = max(c.r, max(c.g, c.b));
	number delta = high - low;
	number sum = high+low;

	vec4 hsl = vec4(.0, .0, .5 * sum, c.a);
	if (delta == .0)
		return hsl;

	hsl.y = (hsl.z < .5) ? delta / sum : delta / (2.0 - sum);

	if (high == c.r)
		hsl.x = (c.g - c.b) / delta;
	else if (high == c.g)
		hsl.x = (c.b - c.r) / delta + 2.0;
	else
		hsl.x = (c.r - c.g) / delta + 4.0;

	hsl.x = mod(hsl.x / 6., 1.);
	return hsl;
}

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a*0.3: tex.a);
    }

    float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01; //Adjusting 0.0-1.0 to fall to -0.1 - 1.1 scale so the mask does not pause at extreme values

	float t = time * 10.0 + 2003.;
	vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);

	vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
	vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
	vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.+ (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;
    vec2 borders = vec2(0.2, 0.8);

    float res = (.5 + .5* cos( (adjusted_dissolve) / 82.612 + ( field + -.5 ) *3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(5. + 5.*dissolve) : 0.)*(dissolve);

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            tex.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a*0.3: tex.a) : .0);
}

// for transforming the card while your mouse is on it
extern PRECISION vec2 mouse_screen_pos;
extern PRECISION float hovering;
extern PRECISION float screen_scale;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    if (hovering <= 0.){
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.2*(-0.03 - 0.3*max(0., 0.3-mid_dist))
                *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);

    return transform_projection * vertex_position + vec4(0.0,0.0,0.0,scale);
}
#endif
