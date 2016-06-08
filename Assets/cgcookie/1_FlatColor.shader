Shader "Custom/1_FlatColor"{
	Properties {
		_Color ("Color", Color) = (1, 1, 1, 1)
		
	}
	SubShader{
		Pass{
			CGPROGRAM
			//pragmas
			#pragma vertex myVertFunc
			#pragma fragment myFragFunc

			//vars
			uniform float4 _Color;

			//structs
			struct vertexInput{
				float4 ver : POSITION;
			};
			struct vertexOutput{
				float4 pos : SV_POSITION;
			};

			//vertex func
			vertexOutput myVertFunc(vertexInput v){
				 vertexOutput o;

				 o.pos = mul(UNITY_MATRIX_MVP, v.ver);

				 return o;
			}

			//frag func
			float4 myFragFunc(vertexOutput i) : COLOR{
				return _Color;
			}
			ENDCG
		}	
	}
	//Fallback "Diffuse"
}
