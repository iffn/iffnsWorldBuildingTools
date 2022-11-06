// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "iffnsShaders/WorldTools/AutoTexture/AutoMeshTerrainTexture"
{
	Properties
	{
		_Texture4("Texture4", 2D) = "white" {}
		_Height34("Height 3-4", Float) = 35
		_Blend34("Blend 3-4", Float) = 1
		_Texture8("Texture3", 2D) = "white" {}
		_Height23("Height 2-3", Float) = 15
		_Blend23("Blend 2-3", Float) = 1
		_Texture6("Texture2", 2D) = "white" {}
		_Height12("Height 1-2", Float) = 2
		_Blend12("Blend 1-2", Float) = 1
		_Texture7("Texture1", 2D) = "white" {}
		__Clifftexture("Clifftexture", 2D) = "white" {}
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

		UNITY_DECLARE_TEX2D_NOSAMPLER(__Clifftexture);
		uniform float4 __Clifftexture_ST;
		SamplerState sampler__Clifftexture;
		uniform float _CliffthresholdDeg;
		uniform float _Cliffblend;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Texture4);
		uniform float4 _Texture4_ST;
		SamplerState sampler_Texture4;
		uniform float _Height34;
		uniform float _Blend34;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Texture8);
		uniform float4 _Texture8_ST;
		SamplerState sampler_Texture8;
		uniform float _Height23;
		uniform float _Blend23;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Texture6);
		uniform float4 _Texture6_ST;
		SamplerState sampler_Texture6;
		uniform float _Height12;
		uniform float _Blend12;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Texture7);
		uniform float4 _Texture7_ST;
		SamplerState sampler_Texture7;

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
			float temp_output_1_0_g590 = ( _Height34 + 0.0 );
			float temp_output_9_0_g590 = _Blend34;
			float temp_output_1_0_g591 = ( temp_output_1_0_g590 - temp_output_9_0_g590 );
			float Level4Splat293 = ( ( 1.0 - CliffSplat284 ) * saturate( ( ( ase_worldPos.y - temp_output_1_0_g591 ) / ( ( temp_output_1_0_g590 + temp_output_9_0_g590 ) - temp_output_1_0_g591 ) ) ) );
			float temp_output_23_0_g592 = 0.0;
			float temp_output_1_0_g594 = ( _Height34 + temp_output_23_0_g592 );
			float temp_output_9_0_g594 = _Blend34;
			float temp_output_1_0_g595 = ( temp_output_1_0_g594 + temp_output_9_0_g594 );
			float temp_output_1_0_g596 = ( temp_output_23_0_g592 + _Height23 );
			float temp_output_9_0_g596 = _Blend23;
			float temp_output_1_0_g597 = ( temp_output_1_0_g596 + temp_output_9_0_g596 );
			float Level3Splat294 = ( ( 1.0 - CliffSplat284 ) * ( saturate( ( ( ase_worldPos.y - temp_output_1_0_g595 ) / ( ( temp_output_1_0_g594 - temp_output_9_0_g594 ) - temp_output_1_0_g595 ) ) ) - saturate( ( ( ase_worldPos.y - temp_output_1_0_g597 ) / ( ( temp_output_1_0_g596 - temp_output_9_0_g596 ) - temp_output_1_0_g597 ) ) ) ) );
			float temp_output_23_0_g580 = 0.0;
			float temp_output_1_0_g582 = ( _Height23 + temp_output_23_0_g580 );
			float temp_output_9_0_g582 = _Blend23;
			float temp_output_1_0_g583 = ( temp_output_1_0_g582 + temp_output_9_0_g582 );
			float temp_output_1_0_g584 = ( temp_output_23_0_g580 + _Height12 );
			float temp_output_9_0_g584 = _Blend12;
			float temp_output_1_0_g585 = ( temp_output_1_0_g584 + temp_output_9_0_g584 );
			float Level2Splat295 = ( ( 1.0 - CliffSplat284 ) * ( saturate( ( ( ase_worldPos.y - temp_output_1_0_g583 ) / ( ( temp_output_1_0_g582 - temp_output_9_0_g582 ) - temp_output_1_0_g583 ) ) ) - saturate( ( ( ase_worldPos.y - temp_output_1_0_g585 ) / ( ( temp_output_1_0_g584 - temp_output_9_0_g584 ) - temp_output_1_0_g585 ) ) ) ) );
			float temp_output_1_0_g587 = ( 0.0 + _Height12 );
			float temp_output_9_0_g587 = _Blend12;
			float temp_output_1_0_g588 = ( temp_output_1_0_g587 + temp_output_9_0_g587 );
			float Level1Splat296 = ( ( 1.0 - CliffSplat284 ) * saturate( ( ( ase_worldPos.y - temp_output_1_0_g588 ) / ( ( temp_output_1_0_g587 - temp_output_9_0_g587 ) - temp_output_1_0_g588 ) ) ) );
			o.Albedo = ( ( SAMPLE_TEXTURE2D( __Clifftexture, sampler__Clifftexture, ( ( UVCoordinate259 * __Clifftexture_ST.xy ) + __Clifftexture_ST.zw ) ) * CliffSplat284 ) + ( SAMPLE_TEXTURE2D( _Texture4, sampler_Texture4, ( ( UVCoordinate259 * _Texture4_ST.xy ) + _Texture4_ST.zw ) ) * Level4Splat293 ) + ( SAMPLE_TEXTURE2D( _Texture8, sampler_Texture8, ( ( UVCoordinate259 * _Texture8_ST.xy ) + _Texture8_ST.zw ) ) * Level3Splat294 ) + ( SAMPLE_TEXTURE2D( _Texture6, sampler_Texture6, ( ( UVCoordinate259 * _Texture6_ST.xy ) + _Texture6_ST.zw ) ) * Level2Splat295 ) + ( SAMPLE_TEXTURE2D( _Texture7, sampler_Texture7, ( ( UVCoordinate259 * _Texture7_ST.xy ) + _Texture7_ST.zw ) ) * Level1Splat296 ) ).rgb;
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
-126;146;1186;715;-1805.642;-873.9377;3.372537;True;False
Node;AmplifyShaderEditor.CommentaryNode;314;870.4138,710.9299;Inherit;False;946.4196;381.6798;Steepness splat;4;145;143;284;315;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;298;-289.8094,1192.02;Inherit;False;946.4196;381.6798;UV map;5;259;273;274;260;261;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;145;906.7183,833.7775;Inherit;False;Property;_CliffthresholdDeg;Cliff threshold Deg;11;0;Create;True;0;0;0;False;0;False;45;0.83;0;90;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;908.267,910.4597;Inherit;False;Property;_Cliffblend;Cliff blend;12;0;Create;True;0;0;0;False;0;False;2.5;0.041;0.0001;25;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;260;-227.651,1276.365;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;261;20.95304,1300.804;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;237;2485.698,1139.27;Inherit;False;2196.924;1444.652;Texture assignment;41;310;304;302;303;300;301;343;306;341;305;342;345;307;308;344;309;339;336;337;338;340;331;335;334;332;333;330;327;328;326;325;324;323;322;321;329;318;316;317;319;320;;0,1,0,1;0;0
Node;AmplifyShaderEditor.FunctionNode;315;1236.805,871.9225;Inherit;False;TerrainSteepnessSplat;-1;;524;8c055b56f2a280245ae7d5a697601bd0;0;2;9;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;236;805.8594,1173.502;Inherit;False;1590.783;1067.842;Splatmap Height;22;295;296;294;293;20;88;86;21;87;17;292;291;279;290;289;278;288;287;286;285;282;277;;1,1,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;259;398.875,1377.629;Inherit;False;UVCoordinate;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;284;1565.777,878.3554;Inherit;False;CliffSplat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;869.4251,1467.225;Inherit;False;Property;_Height34;Height 3-4;1;0;Create;True;0;0;0;False;0;False;35;70;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;876.9944,1547.338;Inherit;False;Property;_Blend34;Blend 3-4;2;0;Create;True;0;0;0;False;0;False;1;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;866.8585,1789.349;Inherit;False;Property;_Blend23;Blend 2-3;5;0;Create;True;0;0;0;False;0;False;1;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;316;2655.935,1477.826;Inherit;True;Property;_Texture4;Texture4;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;318;2647.856,2263.453;Inherit;True;Property;_Texture7;Texture1;9;0;Create;False;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;317;2657.723,2013.11;Inherit;True;Property;_Texture6;Texture2;6;0;Create;False;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;20;857.1243,1705.986;Inherit;False;Property;_Height23;Height 2-3;4;0;Create;True;0;0;0;False;0;False;15;23.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;319;2651.263,1740.02;Inherit;True;Property;_Texture8;Texture3;3;0;Create;False;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;320;2644.784,1208.092;Inherit;True;Property;__Clifftexture;Clifftexture;10;0;Create;False;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;17;858.5262,1991.549;Inherit;False;Property;_Height12;Height 1-2;7;0;Create;True;0;0;0;False;0;False;2;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;863.5893,2073.025;Inherit;False;Property;_Blend12;Blend 1-2;8;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;330;2966.494,1355.718;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureTransformNode;327;2953.461,1644.338;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.FunctionNode;278;1304.686,1848.797;Inherit;False;TerrainHeightToSplatMiddle;-1;;580;83724a7e3c36a4a489f9cbbe3da25c42;0;5;14;FLOAT;0;False;11;FLOAT;0;False;12;FLOAT;0;False;23;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;279;1298.862,2081.012;Inherit;False;TerrainHeightToSplatBottom;-1;;586;2c6309721afd4e747a528bf7483f5d16;0;3;4;FLOAT;0;False;5;FLOAT;0;False;17;FLOAT;0;False;1;FLOAT;10
Node;AmplifyShaderEditor.GetLocalVarNode;291;1410.516,2013.023;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;282;1321.861,1416.559;Inherit;False;TerrainHeightToSplatTop;-1;;589;66045d6e1f6978145ba9fcbdc1decb72;0;3;4;FLOAT;0;False;5;FLOAT;0;False;19;FLOAT;0;False;1;FLOAT;10
Node;AmplifyShaderEditor.GetLocalVarNode;287;1404.423,1531.28;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;277;1305.636,1606.5;Inherit;False;TerrainHeightToSplatMiddle;-1;;592;83724a7e3c36a4a489f9cbbe3da25c42;0;5;14;FLOAT;0;False;11;FLOAT;0;False;12;FLOAT;0;False;23;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;289;1407.604,1772.736;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;285;1410.188,1274.018;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;326;2954.994,2418.462;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.GetLocalVarNode;325;2971.557,2084.146;Inherit;False;259;UVCoordinate;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;324;2958.813,1907.604;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.GetLocalVarNode;323;2953.997,1825.275;Inherit;False;259;UVCoordinate;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;322;2964.905,1570.129;Inherit;False;259;UVCoordinate;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;321;2983.117,1270.533;Inherit;False;259;UVCoordinate;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;329;2961.69,2334.489;Inherit;False;259;UVCoordinate;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;328;2976.375,2166.474;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;331;3238.51,2352.818;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;288;1708.856,1571.589;Inherit;False;TerrainCombineLevelAndSteepnessSplat;-1;;598;6f98bedd32a6e404dbb05d96831fad96;0;2;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;12
Node;AmplifyShaderEditor.FunctionNode;286;1709.996,1354.797;Inherit;False;TerrainCombineLevelAndSteepnessSplat;-1;;600;6f98bedd32a6e404dbb05d96831fad96;0;2;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;12
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;3248.376,2102.475;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;290;1712.037,1813.045;Inherit;False;TerrainCombineLevelAndSteepnessSplat;-1;;601;6f98bedd32a6e404dbb05d96831fad96;0;2;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;12
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;334;3232.253,1304.435;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;332;3230.815,1843.604;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;333;3224.071,1580.338;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;292;1714.949,2032.945;Inherit;False;TerrainCombineLevelAndSteepnessSplat;-1;;599;6f98bedd32a6e404dbb05d96831fad96;0;2;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;12
Node;AmplifyShaderEditor.SimpleAddOpNode;336;3408.375,2166.474;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;340;3384.074,1644.338;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;294;2171.46,1560.962;Inherit;False;Level3Splat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;338;3400.401,1349.653;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;337;3390.817,1907.604;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;296;2165.86,2017.401;Inherit;False;Level1Splat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;293;2157.48,1360.654;Inherit;False;Level4Splat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;339;3398.505,2416.817;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;295;2171.641,1794.962;Inherit;False;Level2Splat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;306;4006.302,2085.473;Inherit;False;295;Level2Splat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;343;3594.685,2265.89;Inherit;True;Property;a;a;37;0;Create;False;0;0;0;False;0;False;-1;None;c1f47f585d1f89143a2288b5b6fa803c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;341;3611.146,1206.338;Inherit;True;Property;a1;a;39;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;305;3983.898,2374.241;Inherit;False;296;Level1Splat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;342;3594.53,2015.336;Inherit;True;Property;s;s;34;0;Create;False;0;0;0;False;0;False;-1;None;e0c0f250770eef24994a6a31d68c5f67;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;307;4001.38,1858.43;Inherit;False;294;Level3Splat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;308;4021.38,1631.43;Inherit;False;293;Level4Splat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;344;3595.332,1485.243;Inherit;True;Property;;;0;0;Create;False;0;0;0;False;0;False;-1;None;1d36785a45a4e30459e65366589a47c0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;309;4006.302,1343.697;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;345;3589.972,1744.102;Inherit;True;Property;d;s;30;0;Create;False;0;0;0;False;0;False;-1;None;9f762073d021f7043b3ed17ab74cd19e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;302;4266.36,1744.065;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;301;4266.459,1476.761;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;300;4246.749,1252.208;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;303;4247.982,2012.44;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;239;4801.536,1533.177;Inherit;False;509.3618;489.544;Assign;2;0;215;;0,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;258;48.37143,763.4542;Inherit;False;539.8882;230.332;Sample states;2;242;241;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;4236.237,2310.247;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;235;-427.7214,1772.033;Inherit;False;1121.118;439.5583;Layer height noise;8;275;230;226;227;234;232;233;228;;1,0,0,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;227;-65.90945,1829.759;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerStateNode;241;100.7274,889.3333;Inherit;False;0;0;0;1;-1;None;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-415.5994,2015.83;Inherit;False;Property;_Noisescale;Noise scale;14;0;Create;True;0;0;0;False;0;False;0.5;0.023;0.023;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;232;-91.16628,1971.195;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;310;4527.257,1572.071;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;273;217.1479,1365.867;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;215;4826.599,1689.319;Inherit;False;Constant;_Float10;Float 10;22;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;274;12.86652,1454.508;Inherit;False;Constant;_Float0;Float 0;16;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ExpOpNode;234;59.99806,1979.107;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;233;-318.1663,1927.196;Inherit;False;Constant;_Float11;Float 11;28;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;242;346.0177,877.6016;Inherit;False;AlbedoSampleState;-1;True;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;226;229.3906,1958.718;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;275;494.9918,1959.873;Inherit;False;Layerheightnoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;230;-417.6175,2115.363;Inherit;False;Property;_Noiseheight;Noise height;13;0;Create;True;0;0;0;False;0;False;0;2.9;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;5069.192,1573.01;Float;False;True;-1;2;;0;0;Standard;iffnsShaders/WorldTools/AutoTexture/AutoMeshTerrainTexture;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;261;0;260;1
WireConnection;261;1;260;3
WireConnection;315;9;145;0
WireConnection;315;10;143;0
WireConnection;259;0;261;0
WireConnection;284;0;315;0
WireConnection;330;0;320;0
WireConnection;327;0;316;0
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
WireConnection;326;0;318;0
WireConnection;324;0;319;0
WireConnection;328;0;317;0
WireConnection;331;0;329;0
WireConnection;331;1;326;0
WireConnection;288;5;287;0
WireConnection;288;6;277;0
WireConnection;286;5;285;0
WireConnection;286;6;282;10
WireConnection;335;0;325;0
WireConnection;335;1;328;0
WireConnection;290;5;289;0
WireConnection;290;6;278;0
WireConnection;334;0;321;0
WireConnection;334;1;330;0
WireConnection;332;0;323;0
WireConnection;332;1;324;0
WireConnection;333;0;322;0
WireConnection;333;1;327;0
WireConnection;292;5;291;0
WireConnection;292;6;279;10
WireConnection;336;0;335;0
WireConnection;336;1;328;1
WireConnection;340;0;333;0
WireConnection;340;1;327;1
WireConnection;294;0;288;12
WireConnection;338;0;334;0
WireConnection;338;1;330;1
WireConnection;337;0;332;0
WireConnection;337;1;324;1
WireConnection;296;0;292;12
WireConnection;293;0;286;12
WireConnection;339;0;331;0
WireConnection;339;1;326;1
WireConnection;295;0;290;12
WireConnection;343;0;318;0
WireConnection;343;1;339;0
WireConnection;341;0;320;0
WireConnection;341;1;338;0
WireConnection;342;0;317;0
WireConnection;342;1;336;0
WireConnection;344;0;316;0
WireConnection;344;1;340;0
WireConnection;345;0;319;0
WireConnection;345;1;337;0
WireConnection;302;0;345;0
WireConnection;302;1;307;0
WireConnection;301;0;344;0
WireConnection;301;1;308;0
WireConnection;300;0;341;0
WireConnection;300;1;309;0
WireConnection;303;0;342;0
WireConnection;303;1;306;0
WireConnection;304;0;343;0
WireConnection;304;1;305;0
WireConnection;232;0;233;0
WireConnection;232;1;228;0
WireConnection;310;0;300;0
WireConnection;310;1;301;0
WireConnection;310;2;302;0
WireConnection;310;3;303;0
WireConnection;310;4;304;0
WireConnection;273;0;261;0
WireConnection;273;2;274;0
WireConnection;234;0;232;0
WireConnection;242;0;241;0
WireConnection;226;0;227;0
WireConnection;226;1;234;0
WireConnection;275;0;226;0
WireConnection;0;0;310;0
WireConnection;0;3;215;0
WireConnection;0;4;215;0
ASEEND*/
//CHKSM=2C682240C8DD212EC7A067B198D26807CEE3B95E