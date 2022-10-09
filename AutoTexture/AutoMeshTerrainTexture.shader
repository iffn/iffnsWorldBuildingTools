// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "iffnsShaders/WorldTools/AutoTexture/AutoMeshTerrainTexture"
{
	Properties
	{
		[NoScaleOffset]_Texture4("Texture4", 2D) = "white" {}
		_Height34("Height 3-4", Float) = 35
		_Blend34("Blend 3-4", Float) = 1
		[NoScaleOffset]_Texture3("Texture3", 2D) = "white" {}
		_Height23("Height 2-3", Float) = 15
		_Blend23("Blend 2-3", Float) = 1
		[NoScaleOffset]_Texture2("Texture2", 2D) = "white" {}
		_Height12("Height 1-2", Float) = 2
		_Blend12("Blend 1-2", Float) = 1
		[NoScaleOffset]_Texture1("Texture1", 2D) = "white" {}
		[NoScaleOffset]_Clifftexture("Cliff texture", 2D) = "white" {}
		_CliffthresholdDeg("Cliff threshold Deg", Range( 0 , 90)) = 45
		_Cliffblend("Cliff blend", Range( 0.0001 , 25)) = 2.5
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		UNITY_DECLARE_TEX2D_NOSAMPLER(_Clifftexture);
		SamplerState sampler_Clifftexture;
		uniform float _CliffthresholdDeg;
		uniform float _Cliffblend;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Texture4);
		SamplerState sampler_Texture4;
		uniform float _Height34;
		uniform float _Blend34;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Texture3);
		SamplerState sampler_Texture3;
		uniform float _Height23;
		uniform float _Blend23;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Texture2);
		SamplerState sampler_Texture2;
		uniform float _Height12;
		uniform float _Blend12;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Texture1);
		SamplerState sampler_Texture1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult261 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 UVCoordinate259 = appendResult261;
			float3 ase_worldNormal = i.worldNormal;
			float temp_output_22_0_g524 = cos( ( _CliffthresholdDeg * 0.01745328 ) );
			float temp_output_20_0_g524 = ( 0.01745328 * _Cliffblend );
			float temp_output_1_0_g525 = ( temp_output_22_0_g524 + temp_output_20_0_g524 );
			float CliffSplat284 = saturate( ( ( ase_worldNormal.y - temp_output_1_0_g525 ) / ( ( temp_output_22_0_g524 - temp_output_20_0_g524 ) - temp_output_1_0_g525 ) ) );
			float temp_output_1_0_g569 = ( _Height34 + 0.0 );
			float temp_output_9_0_g569 = _Blend34;
			float temp_output_1_0_g570 = ( temp_output_1_0_g569 - temp_output_9_0_g569 );
			float Level4Splat293 = ( ( 1.0 - CliffSplat284 ) * saturate( ( ( ase_worldPos.y - temp_output_1_0_g570 ) / ( ( temp_output_1_0_g569 + temp_output_9_0_g569 ) - temp_output_1_0_g570 ) ) ) );
			float temp_output_23_0_g571 = 0.0;
			float temp_output_1_0_g573 = ( _Height34 + temp_output_23_0_g571 );
			float temp_output_9_0_g573 = _Blend34;
			float temp_output_1_0_g574 = ( temp_output_1_0_g573 + temp_output_9_0_g573 );
			float temp_output_1_0_g575 = ( temp_output_23_0_g571 + _Height23 );
			float temp_output_9_0_g575 = _Blend23;
			float temp_output_1_0_g576 = ( temp_output_1_0_g575 + temp_output_9_0_g575 );
			float Level3Splat294 = ( ( 1.0 - CliffSplat284 ) * ( saturate( ( ( ase_worldPos.y - temp_output_1_0_g574 ) / ( ( temp_output_1_0_g573 - temp_output_9_0_g573 ) - temp_output_1_0_g574 ) ) ) - saturate( ( ( ase_worldPos.y - temp_output_1_0_g576 ) / ( ( temp_output_1_0_g575 - temp_output_9_0_g575 ) - temp_output_1_0_g576 ) ) ) ) );
			float temp_output_23_0_g580 = 0.0;
			float temp_output_1_0_g582 = ( _Height23 + temp_output_23_0_g580 );
			float temp_output_9_0_g582 = _Blend23;
			float temp_output_1_0_g583 = ( temp_output_1_0_g582 + temp_output_9_0_g582 );
			float temp_output_1_0_g584 = ( temp_output_23_0_g580 + _Height12 );
			float temp_output_9_0_g584 = _Blend12;
			float temp_output_1_0_g585 = ( temp_output_1_0_g584 + temp_output_9_0_g584 );
			float Level2Splat295 = ( ( 1.0 - CliffSplat284 ) * ( saturate( ( ( ase_worldPos.y - temp_output_1_0_g583 ) / ( ( temp_output_1_0_g582 - temp_output_9_0_g582 ) - temp_output_1_0_g583 ) ) ) - saturate( ( ( ase_worldPos.y - temp_output_1_0_g585 ) / ( ( temp_output_1_0_g584 - temp_output_9_0_g584 ) - temp_output_1_0_g585 ) ) ) ) );
			float temp_output_1_0_g578 = ( 0.0 + _Height12 );
			float temp_output_9_0_g578 = _Blend12;
			float temp_output_1_0_g579 = ( temp_output_1_0_g578 + temp_output_9_0_g578 );
			float Level1Splat296 = ( ( 1.0 - CliffSplat284 ) * saturate( ( ( ase_worldPos.y - temp_output_1_0_g579 ) / ( ( temp_output_1_0_g578 - temp_output_9_0_g578 ) - temp_output_1_0_g579 ) ) ) );
			o.Albedo = ( ( SAMPLE_TEXTURE2D( _Clifftexture, sampler_Clifftexture, UVCoordinate259 ) * CliffSplat284 ) + ( SAMPLE_TEXTURE2D( _Texture4, sampler_Texture4, UVCoordinate259 ) * Level4Splat293 ) + ( SAMPLE_TEXTURE2D( _Texture3, sampler_Texture3, UVCoordinate259 ) * Level3Splat294 ) + ( SAMPLE_TEXTURE2D( _Texture2, sampler_Texture2, UVCoordinate259 ) * Level2Splat295 ) + ( SAMPLE_TEXTURE2D( _Texture1, sampler_Texture1, UVCoordinate259 ) * Level1Splat296 ) ).rgb;
			float temp_output_215_0 = 0.0;
			o.Metallic = temp_output_215_0;
			o.Smoothness = temp_output_215_0;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18935
418;183;918;646;-1546.285;-959.4643;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;314;870.4138,710.9299;Inherit;False;946.4196;381.6798;Steepness splat;4;145;143;284;315;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;145;906.7183,833.7775;Inherit;False;Property;_CliffthresholdDeg;Cliff threshold Deg;11;0;Create;True;0;0;0;False;0;False;45;0.83;0;90;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;908.267,910.4597;Inherit;False;Property;_Cliffblend;Cliff blend;12;0;Create;True;0;0;0;False;0;False;2.5;0.041;0.0001;25;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;298;-289.8094,1192.02;Inherit;False;946.4196;381.6798;UV map;5;259;273;274;260;261;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;236;805.8594,1173.502;Inherit;False;1590.783;1067.842;Splatmap Height;22;295;296;294;293;20;88;86;21;87;17;292;291;279;290;289;278;288;287;286;285;282;277;;1,1,0,1;0;0
Node;AmplifyShaderEditor.FunctionNode;315;1236.805,871.9225;Inherit;False;TerrainSteepnessSplat;-1;;524;8c055b56f2a280245ae7d5a697601bd0;0;2;9;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;857.1243,1705.986;Inherit;False;Property;_Height23;Height 2-3;4;0;Create;True;0;0;0;False;0;False;15;23.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;858.5262,1991.549;Inherit;False;Property;_Height12;Height 1-2;7;0;Create;True;0;0;0;False;0;False;2;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;284;1565.777,878.3554;Inherit;False;CliffSplat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;869.4251,1467.225;Inherit;False;Property;_Height34;Height 3-4;1;0;Create;True;0;0;0;False;0;False;35;70;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;260;-227.651,1276.365;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;86;876.9944,1547.338;Inherit;False;Property;_Blend34;Blend 3-4;2;0;Create;True;0;0;0;False;0;False;1;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;866.8585,1789.349;Inherit;False;Property;_Blend23;Blend 2-3;5;0;Create;True;0;0;0;False;0;False;1;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;863.5893,2073.025;Inherit;False;Property;_Blend12;Blend 1-2;8;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;261;20.95304,1300.804;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;278;1304.686,1848.797;Inherit;False;TerrainHeightToSplatMiddle;-1;;580;83724a7e3c36a4a489f9cbbe3da25c42;0;5;14;FLOAT;0;False;11;FLOAT;0;False;12;FLOAT;0;False;23;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;279;1298.862,2081.012;Inherit;False;TerrainHeightToSplatBottom;-1;;577;2c6309721afd4e747a528bf7483f5d16;0;3;4;FLOAT;0;False;5;FLOAT;0;False;17;FLOAT;0;False;1;FLOAT;10
Node;AmplifyShaderEditor.GetLocalVarNode;291;1410.516,2013.023;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;282;1321.861,1416.559;Inherit;False;TerrainHeightToSplatTop;-1;;568;66045d6e1f6978145ba9fcbdc1decb72;0;3;4;FLOAT;0;False;5;FLOAT;0;False;19;FLOAT;0;False;1;FLOAT;10
Node;AmplifyShaderEditor.GetLocalVarNode;287;1404.423,1531.28;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;277;1305.636,1606.5;Inherit;False;TerrainHeightToSplatMiddle;-1;;571;83724a7e3c36a4a489f9cbbe3da25c42;0;5;14;FLOAT;0;False;11;FLOAT;0;False;12;FLOAT;0;False;23;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;285;1410.188,1274.018;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;289;1407.604,1772.736;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;288;1708.856,1571.589;Inherit;False;TerrainCombineLevelAndSteepnessSplat;-1;;586;6f98bedd32a6e404dbb05d96831fad96;0;2;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;12
Node;AmplifyShaderEditor.FunctionNode;292;1714.949,2032.945;Inherit;False;TerrainCombineLevelAndSteepnessSplat;-1;;587;6f98bedd32a6e404dbb05d96831fad96;0;2;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;12
Node;AmplifyShaderEditor.FunctionNode;286;1709.996,1354.797;Inherit;False;TerrainCombineLevelAndSteepnessSplat;-1;;588;6f98bedd32a6e404dbb05d96831fad96;0;2;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;12
Node;AmplifyShaderEditor.FunctionNode;290;1712.037,1813.045;Inherit;False;TerrainCombineLevelAndSteepnessSplat;-1;;589;6f98bedd32a6e404dbb05d96831fad96;0;2;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;12
Node;AmplifyShaderEditor.CommentaryNode;237;2485.698,1139.27;Inherit;False;1591.322;1240.927;Texture assignment;19;310;300;309;308;307;306;305;304;303;302;301;299;272;271;178;177;176;175;179;;0,1,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;259;398.875,1377.629;Inherit;False;UVCoordinate;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;271;2557.615,2009.223;Inherit;False;259;UVCoordinate;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;294;2171.46,1560.962;Inherit;False;Level3Splat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;296;2165.86,2017.401;Inherit;False;Level1Splat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;293;2157.48,1360.654;Inherit;False;Level4Splat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;272;2558.592,1699.373;Inherit;False;259;UVCoordinate;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;295;2171.641,1794.962;Inherit;False;Level2Splat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;299;2587.131,1233.979;Inherit;False;259;UVCoordinate;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;305;3250.121,2246.25;Inherit;False;296;Level1Splat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;175;2940.231,1470.977;Inherit;True;Property;_Texture4;Texture4;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;1d36785a45a4e30459e65366589a47c0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;306;3256.121,2013.251;Inherit;False;295;Level2Splat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;176;2945.396,1689.386;Inherit;True;Property;_Texture3;Texture3;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;9f762073d021f7043b3ed17ab74cd19e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;178;2958.054,2131.027;Inherit;True;Property;_Texture1;Texture1;9;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;c1f47f585d1f89143a2288b5b6fa803c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;177;2949.6,1895.277;Inherit;True;Property;_Texture2;Texture2;6;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;e0c0f250770eef24994a6a31d68c5f67;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;307;3256.121,1804.251;Inherit;False;294;Level3Splat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;308;3276.121,1577.251;Inherit;False;293;Level4Splat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;309;3256.121,1368.251;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;179;2934.022,1263.429;Inherit;True;Property;_Clifftexture;Cliff texture;10;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;239;4174.89,1428.03;Inherit;False;509.3618;489.544;Assign;2;0;215;;0,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;258;48.37143,763.4542;Inherit;False;539.8882;230.332;Sample states;2;242;241;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;300;3519.532,1273.481;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;235;-427.7214,1772.033;Inherit;False;1121.118;439.5583;Layer height noise;8;275;230;226;227;234;232;233;228;;1,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;3504.101,2208.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;301;3532.683,1525.919;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;303;3510.924,1982.865;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;302;3527.662,1768.619;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;233;-318.1663,1927.196;Inherit;False;Constant;_Float11;Float 11;28;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;275;494.9918,1959.873;Inherit;False;Layerheightnoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-415.5994,2015.83;Inherit;False;Property;_Noisescale;Noise scale;14;0;Create;True;0;0;0;False;0;False;0.5;0.023;0.023;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;215;4199.953,1584.173;Inherit;False;Constant;_Float10;Float 10;22;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;226;229.3906,1958.718;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ExpOpNode;234;59.99806,1979.107;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;274;12.86652,1454.508;Inherit;False;Constant;_Float0;Float 0;16;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;230;-417.6175,2115.363;Inherit;False;Property;_Noiseheight;Noise height;13;0;Create;True;0;0;0;False;0;False;0;2.9;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;227;-65.90945,1829.759;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;232;-91.16628,1971.195;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerStateNode;241;100.7274,889.3333;Inherit;False;0;0;0;1;-1;None;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;273;217.1479,1365.867;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;242;346.0177,877.6016;Inherit;False;AlbedoSampleState;-1;True;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SimpleAddOpNode;310;3910.233,1481.817;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4442.547,1467.863;Float;False;True;-1;2;;0;0;Standard;iffnsShaders/WorldTools/AutoTexture/AutoMeshTerrainTexture;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;315;9;145;0
WireConnection;315;10;143;0
WireConnection;284;0;315;0
WireConnection;261;0;260;1
WireConnection;261;1;260;3
WireConnection;278;14;20;0
WireConnection;278;11;87;0
WireConnection;278;12;17;0
WireConnection;278;13;88;0
WireConnection;279;4;17;0
WireConnection;279;5;88;0
WireConnection;282;4;21;0
WireConnection;282;5;86;0
WireConnection;277;14;21;0
WireConnection;277;11;86;0
WireConnection;277;12;20;0
WireConnection;277;13;87;0
WireConnection;288;5;287;0
WireConnection;288;6;277;0
WireConnection;292;5;291;0
WireConnection;292;6;279;10
WireConnection;286;5;285;0
WireConnection;286;6;282;10
WireConnection;290;5;289;0
WireConnection;290;6;278;0
WireConnection;259;0;261;0
WireConnection;294;0;288;12
WireConnection;296;0;292;12
WireConnection;293;0;286;12
WireConnection;295;0;290;12
WireConnection;175;1;272;0
WireConnection;176;1;272;0
WireConnection;178;1;271;0
WireConnection;177;1;271;0
WireConnection;179;1;299;0
WireConnection;300;0;179;0
WireConnection;300;1;309;0
WireConnection;304;0;178;0
WireConnection;304;1;305;0
WireConnection;301;0;175;0
WireConnection;301;1;308;0
WireConnection;303;0;177;0
WireConnection;303;1;306;0
WireConnection;302;0;176;0
WireConnection;302;1;307;0
WireConnection;275;0;226;0
WireConnection;226;0;227;0
WireConnection;226;1;234;0
WireConnection;234;0;232;0
WireConnection;232;0;233;0
WireConnection;232;1;228;0
WireConnection;273;0;261;0
WireConnection;273;2;274;0
WireConnection;242;0;241;0
WireConnection;310;0;300;0
WireConnection;310;1;301;0
WireConnection;310;2;302;0
WireConnection;310;3;303;0
WireConnection;310;4;304;0
WireConnection;0;0;310;0
WireConnection;0;3;215;0
WireConnection;0;4;215;0
ASEEND*/
//CHKSM=8AE5E664E697001E1ACB444D86D12897322C5E76