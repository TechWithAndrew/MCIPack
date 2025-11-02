#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:emissive_utils.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec4 vertexColor;
in vec4 lightMapColor;
in vec2 texCoord0;
in vec2 texCoord1;

out vec4 fragColor;

void main() {
    vec4 baseColor = texture(Sampler0, texCoord0) * ColorModulator;

    // Convert alpha to int for make_emissive
    int alphaInt = int(round(baseColor.a * 255.0));

    vec4 color;

    // Use emissive only if alpha > 0 (or any other condition for "emissive")
    if (alphaInt == 254 || alphaInt == 252 || alphaInt == 251) {
        color = make_emissive(baseColor, lightMapColor, vec4(1.0), alphaInt);
    } else {
        color = baseColor * vertexColor;
    }

    if (color.a < 0.1) {
        discard;
    }

    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance,
                          FogEnvironmentalStart, FogEnvironmentalEnd,
                          FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}
