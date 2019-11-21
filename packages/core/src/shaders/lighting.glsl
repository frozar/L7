// Blinn-Phong model
// apply lighting in vertex shader instead of fragment shader
// @see https://learnopengl.com/Advanced-Lighting/Advanced-Lighting
uniform float u_Ambient : 1.0;
uniform float u_Diffuse : 1.0;
uniform float u_Specular : 1.0;
uniform int u_NumOfDirectionalLights : 1;
uniform int u_NumOfSpotLights : 0;

#define SHININESS 32.0
#define MAX_NUM_OF_DIRECTIONAL_LIGHTS 3
#define MAX_NUM_OF_SPOT_LIGHTS 3

struct DirectionalLight {
  vec3 direction;
  vec3 ambient;
  vec3 diffuse;
  vec3 specular;
};

struct SpotLight {
  vec3 position;
  vec3 direction;
  vec3 ambient;
  vec3 diffuse;
  vec3 specular;
  float constant;
  float linear;
  float quadratic;
  float angle;
  float blur;
  float exponent;
};

uniform DirectionalLight u_DirectionalLights[MAX_NUM_OF_DIRECTIONAL_LIGHTS];
uniform SpotLight u_SpotLights[MAX_NUM_OF_SPOT_LIGHTS];

vec3 calc_directional_light(DirectionalLight light, vec3 normal, vec3 viewDir) {
  vec3 lightDir = normalize(light.direction);
  // diffuse shading
  float diff = max(dot(normal, lightDir), 0.0);
  // Blinn-Phong specular shading
  vec3 halfwayDir = normalize(lightDir + viewDir);
  float spec = pow(max(dot(normal, halfwayDir), 0.0), SHININESS);

  vec3 ambient = light.ambient * u_Ambient;
  vec3 diffuse = light.diffuse * diff * u_Diffuse;
  vec3 specular = light.specular * spec * u_Specular;

  return ambient + diffuse + specular;
}

// vec3 calc_spot_light(SpotLight light, vec3 normal, vec3 fragPos, vec3 viewDir) {
//   vec3 lightDir = normalize(light.position - fragPos);
//   // diffuse shading
//   float diff = max(dot(normal, lightDir), 0.0);
//   // specular shading
//   vec3 reflectDir = reflect(-lightDir, normal);
//   float spec = pow(max(dot(viewDir, reflectDir), 0.0), SHININESS);
//   // attenuation
//   float distance = length(light.position - fragPos);
//   float attenuation = 1.0 / (light.constant + light.linear * distance + 
//           light.quadratic * (distance * distance));    

//   vec3 ambient = light.ambient * u_Ambient;
//   vec3 diffuse = light.diffuse * diff * u_Diffuse;
//   vec3 specular = light.specular * spec * u_Specular;

//   float spotEffect = dot(normalize(light.direction), -lightDir);
//   float spotCosCutoff = cos(light.angle / 180.0 * PI);
//   float spotCosOuterCutoff = cos((light.angle + light.blur) / 180.0 * PI);
//   float spotCosInnerCutoff = cos((light.angle - light.blur) / 180.0 * PI);
//   if (spotEffect > spotCosCutoff) {
//     spotEffect = pow(smoothstep(spotCosOuterCutoff, spotCosInnerCutoff, spotEffect), light.exponent);
//   } else {
//     spotEffect = 0.0;
//   }

//   return ambient + attenuation * (spotEffect * diffuse + specular);
// }

vec3 calc_lighting(vec3 position, vec3 normal, vec3 viewDir) {
  vec3 weight = vec3(0.0);
  for (int i = 0; i < MAX_NUM_OF_DIRECTIONAL_LIGHTS; i++) {
    if (i >= u_NumOfDirectionalLights) {
      break;
    }
    weight += calc_directional_light(u_DirectionalLights[i], normal, viewDir);
  }
  // for (int i = 0; i < MAX_NUM_OF_SPOT_LIGHTS; i++) {
  //   if (i >= u_NumOfSpotLights) {
  //     break;
  //   }
  //   weight += calc_spot_light(u_SpotLights[i], normal, position, viewDir);
  // }
  return weight;
}