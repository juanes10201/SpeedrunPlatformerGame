 shader_type canvas_item;
 

 uniform sampler2D texture_albedo;
 uniform vec2 tile_size;
 uniform float speed = 0.5;
 
 void fragment() {
  vec2 uv = UV;
  uv *= tile_size;
  vec2 offset;
  offset.x = TIME * speed;
  offset.y = TIME * speed;
  uv += offset;

  COLOR = texture(TEXTURE, uv);
}