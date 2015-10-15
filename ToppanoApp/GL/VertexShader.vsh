
attribute vec4 aPosition;
attribute vec2 aUV;
attribute vec2 aUV2;

uniform mat4 uProjection;
uniform mat4 uView;
uniform mat4 uModel;

varying vec2 vUV;
varying vec2 vUV2;

void main() {
    gl_Position = uProjection * uView * uModel * aPosition;
    vUV = aUV;
    vUV2 = aUV2;
}
