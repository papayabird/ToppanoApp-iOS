
precision mediump float;

varying vec2 vUV;
varying vec2 vUV2;

uniform sampler2D uTex;
uniform sampler2D uTex2;

uniform int textureMode;

void main() {
    
    if (textureMode == 0) {
        gl_FragColor = texture2D(uTex, vUV);
    }
    else {
        gl_FragColor = texture2D(uTex2, vUV2);
        gl_FragColor.a *= 0.8;
    }
}