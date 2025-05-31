shader_type canvas_item;

uniform vec4 neon_color : source_color = vec4(1.0); //Shine color
uniform float glow_intensity : hint_range(0.0, 5.0) = 1.5;       // Intensité de l'effet néon
uniform float glow_size : hint_range(0.0, 20.0) = 8.0;           // Taille du contour lumineux

void fragment() {
    vec4 base_color = texture(TEXTURE, UV); // Couleur de base du texte
    float alpha = base_color.a;            // Transparence du texte

    // Calcul du contour lumineux
    float glow = glow_size * (1.0 - alpha);
    vec4 glow_effect = neon_color * glow_intensity * glow;

    // Combinaison de la couleur de base et de l'effet néon
    COLOR = base_color + glow_effect;
    COLOR.a = base_color.a; // Conserver la transparence d'origine
}