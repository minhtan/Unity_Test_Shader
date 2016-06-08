Shader "Custom/04c_CutawaysTan" {
	SubShader {
      Pass {
         Cull Off // turn off triangle culling, alternatives are:
         // Cull Back // (or nothing): cull only back faces 
         // Cull Front // : cull only front faces
 
         CGPROGRAM 
 
         #pragma vertex vert  
         #pragma fragment frag 

         uniform float4x4 _otherMatrix;

         struct vertexInput {
            float4 vertex : POSITION;
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 posInWorldCoord : TEXCOORD0;
            float4 posInOther : TEXCOORD1;
         };
 
         vertexOutput vert(vertexInput input) 
         {
            vertexOutput output;
 
            output.pos =  mul(UNITY_MATRIX_MVP, input.vertex);
            output.posInWorldCoord = mul(_Object2World, input.vertex);
            output.posInOther = mul(_otherMatrix, input.vertex);

            return output;
         }
 
         float4 frag(vertexOutput input) : COLOR
         {
//            if ( abs( distance(input.posInOther, float4(0,0,0,0)) ) < 0.5 ) 
            if( input.posInWorldCoord.y > input.posInOther.y)
            {
               discard; // drop the fragment if y coordinate > 0
            }
            return float4(0.0, 1.0, 0.0, 1.0); // green
         }
 
         ENDCG  
      }
   }
}
