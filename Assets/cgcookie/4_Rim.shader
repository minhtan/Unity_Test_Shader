Shader "Custom/4_Rim" {
	Properties{
		_Color  ("Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_Shininess ("Shininess", float) = 10
		_RimColor ("Rim Color", Color) = (1,1,1,1)
		_RimPower ("Rim Power", Range(0.1, 10)) = 3.0
	}
	SubShader{
		Pass{
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			//user vars
			uniform float4 _Color;
			uniform float4 _SpecColor;
			uniform float4 _RimColor;
			uniform float _Shininess;
			uniform float _RimPower;

			//unity vars
			uniform float4 _LightColor0;

			//base input struct
			struct vertexInput{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			struct vertexOutput{
				float4 pos : POSITION;
				float4 posWorld : TEXCOORD0;
				float3 normalDir : TEXCOORD1;
			};

			//vertex function
			vertexOutput vert(vertexInput v){
				vertexOutput o;

				o.posWorld = mul(_Object2World, v.vertex);
				o.normalDir = normalize(mul(float4(v.normal, 0.0), _World2Object).xyz);
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

				return o;
			}

			//fragment function
			float4 frag(vertexOutput i) : COLOR{
				float3 normalDir = i.normalDir;
				float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
				float3 lightDir = normalize( _WorldSpaceLightPos0.xyz);
				float atten = 1.0;

				//lighting
				float3 diffuseRefl = atten * _LightColor0.xyz * saturate(dot(normalDir, lightDir));
				float3 specRefl = atten * _SpecColor.xyz * saturate(dot(normalDir, lightDir)) * pow (saturate(dot(reflect(-lightDir, normalDir), viewDir)), _Shininess);

				//Rim lighting
				float rim = 1 - saturate(dot(normalize(viewDir), normalDir));
				float3 rimLighting = atten * _LightColor0.xyz * _RimColor * saturate(dot(normalDir, lightDir)) * pow(rim, _RimPower);

				float3 lightFinal = rimLighting + diffuseRefl + specRefl + UNITY_LIGHTMODEL_AMBIENT.xyz;
				return float4(lightFinal * _Color.xyz, 1.0);
			}
			ENDCG
		}
	}
	//Fallback "Specular"
}
