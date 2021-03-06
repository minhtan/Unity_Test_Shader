﻿Shader "Custom/3_Specular" {
	Properties{
		_Color ("Color", Color) = (1,1,1,1)
		_SpecColor ("Spec Color", Color) = (1,1,1,1)
		_Shininess ("Shininess", float) = 10
	}
	SubShader{
		Tags {"LightMode" = "ForwardBase"}
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			//user vars
			uniform float4 _Color;
			uniform float4 _SpecColor;
			uniform float _Shininess;
			

			//Unity vars
			uniform float4 _LightColor0;

			//unity 3 definition
//			float4x4 _Object2World;
//			float4x4 _World2Object;
//			float4 _WorldSpaceLightPos0;

			//structs
			struct vertexInput{
				float4 ver : POSITION;	
				float3 norm : NORMAL;
			};
			struct vertexOutput{
				float4 pos : POSITION;
				float4 col : COLOR;
			};

			//vertex func
			vertexOutput vert(vertexInput v){
				vertexOutput o;

				float3 normDir = normalize( mul(float4(v.norm, 0.0), _World2Object).xyz );
				float3 viewDir = normalize( _WorldSpaceCameraPos.xyz - mul(_Object2World, v.ver).xyz );
				float3 lightDir = normalize( _WorldSpaceLightPos0.xyz );
				float atten = 1.0;

				float3 diffuseRefl = atten * _LightColor0.xyz * max (0.0 , dot(normDir, lightDir));
				float3 specRefl = atten * _SpecColor.rgb * max (0.0 , dot(normDir, lightDir)) * pow(max(0.0, dot(reflect(-lightDir, normDir), viewDir)), _Shininess);

				float3 finalLight = (diffuseRefl + specRefl + UNITY_LIGHTMODEL_AMBIENT.xyz) * _Color.rgb;

				o.col = float4(finalLight, 1.0);
				o.pos = mul(UNITY_MATRIX_MVP, v.ver);

				return o;
			}

			//fragment func
			float4 frag(vertexOutput i) : COLOR{
				return i.col;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
