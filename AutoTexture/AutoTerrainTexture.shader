// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "iffnsShaders/WorldTools/AutoTexture/AutoTerrainTexture"
{
	Properties
	{
		_Texture4("Texture4", 2D) = "white" {}
		_Height34("Height 3-4", Float) = 35
		_Blend34("Blend 3-4", Float) = 1
		[HideInInspector]_Splat3("Splat3", 2D) = "white" {}
		[HideInInspector]_Control("Control", 2D) = "white" {}
		[HideInInspector]_Splat2("Splat2", 2D) = "white" {}
		[HideInInspector]_Splat1("Splat1", 2D) = "white" {}
		_Texture3("Texture3", 2D) = "white" {}
		_Height23("Height 2-3", Float) = 15
		_Blend23("Blend 2-3", Float) = 1
		_Texture2("Texture2", 2D) = "white" {}
		_Height12("Height 1-2", Float) = 2
		_Blend12("Blend 1-2", Float) = 1
		_Texture1("Texture1", 2D) = "white" {}
		[HideInInspector]_TerrainHolesTexture("_TerrainHolesTexture", 2D) = "white" {}
		__Clifftexture("Clifftexture", 2D) = "white" {}
		_CliffthresholdDeg("Cliff threshold Deg", Range( 0 , 90)) = 45
		_Cliffblend("Cliff blend", Range( 0.0001 , 25)) = 5
		_SnowHeight("SnowHeight", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
		#pragma multi_compile_instancing
		#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex.SampleLevel(samplerTex,coord, lod)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex2Dlod(tex,float4(coord,0,lod))
		#endif//ASE Sampling Macros

		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
		};

		#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
			sampler2D _TerrainHeightmapTexture;//ASE Terrain Instancing
			sampler2D _TerrainNormalmapTexture;//ASE Terrain Instancing
		#endif//ASE Terrain Instancing
		UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
			UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
		UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
		CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
				float4 _TerrainHeightmapScale;//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
		CBUFFER_END//ASE Terrain Instancing
		uniform float _SnowHeight;
		uniform float _CliffthresholdDeg;
		uniform float _Cliffblend;
		uniform float _Height34;
		uniform float _Blend34;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Control);
		uniform float4 _Control_ST;
		SamplerState sampler_Control;
		UNITY_DECLARE_TEX2D_NOSAMPLER(__Clifftexture);
		uniform float4 __Clifftexture_ST;
		SamplerState sampler__Clifftexture;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Texture4);
		uniform float4 _Texture4_ST;
		SamplerState sampler_Texture4;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Texture3);
		uniform float4 _Texture3_ST;
		SamplerState sampler_Texture3;
		uniform float _Height23;
		uniform float _Blend23;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Texture2);
		uniform float4 _Texture2_ST;
		SamplerState sampler_Texture2;
		uniform float _Height12;
		uniform float _Blend12;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Texture1);
		uniform float4 _Texture1_ST;
		SamplerState sampler_Texture1;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat1);
		uniform float4 _Splat1_ST;
		SamplerState sampler_Splat1;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat2);
		uniform float4 _Splat2_ST;
		SamplerState sampler_Splat2;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat3);
		uniform float4 _Splat3_ST;
		SamplerState sampler_Splat3;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_TerrainHolesTexture);
		uniform float4 _TerrainHolesTexture_ST;
		SamplerState sampler_TerrainHolesTexture;


		void ApplyMeshModification( inout appdata_full v )
		{
			#if defined(UNITY_INSTANCING_ENABLED) && !defined(SHADER_API_D3D11_9X)
				float2 patchVertex = v.vertex.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP(Terrain, _TerrainPatchInstanceData);
				
				float4 uvscale = instanceData.z * _TerrainHeightmapRecipSize;
				float4 uvoffset = instanceData.xyxy * uvscale;
				uvoffset.xy += 0.5f * _TerrainHeightmapRecipSize.xy;
				float2 sampleCoords = (patchVertex.xy * uvscale.xy + uvoffset.xy);
				
				float hm = UnpackHeightmap(tex2Dlod(_TerrainHeightmapTexture, float4(sampleCoords, 0, 0)));
				v.vertex.xz = (patchVertex.xy + instanceData.xy) * _TerrainHeightmapScale.xz * instanceData.z;
				v.vertex.y = hm * _TerrainHeightmapScale.y;
				v.vertex.w = 1.0f;
				
				v.texcoord.xy = (patchVertex.xy * uvscale.zw + uvoffset.zw);
				v.texcoord3 = v.texcoord2 = v.texcoord1 = v.texcoord;
				
				#ifdef TERRAIN_INSTANCED_PERPIXEL_NORMAL
					v.normal = float3(0, 1, 0);
					//data.tc.zw = sampleCoords;
				#else
					float3 nor = tex2Dlod(_TerrainNormalmapTexture, float4(sampleCoords, 0, 0)).xyz;
					v.normal = 2.0f * nor - 1.0f;
				#endif
			#endif
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			ApplyMeshModification(v);;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float temp_output_22_0_g686 = cos( ( _CliffthresholdDeg * 0.01745328 ) );
			float temp_output_20_0_g686 = ( 0.01745328 * _Cliffblend );
			float temp_output_1_0_g687 = ( temp_output_22_0_g686 + temp_output_20_0_g686 );
			float CliffSplat284 = saturate( ( ( ase_worldNormal.y - temp_output_1_0_g687 ) / ( ( temp_output_22_0_g686 - temp_output_20_0_g686 ) - temp_output_1_0_g687 ) ) );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float temp_output_1_0_g740 = ( _Height34 + 0.0 );
			float temp_output_9_0_g740 = _Blend34;
			float temp_output_1_0_g741 = ( temp_output_1_0_g740 - temp_output_9_0_g740 );
			float2 uv_Control = v.texcoord * _Control_ST.xy + _Control_ST.zw;
			float4 tex2DNode317 = SAMPLE_TEXTURE2D_LOD( _Control, sampler_Control, uv_Control, 0.0 );
			float DefaultLayer318 = tex2DNode317.r;
			float Level4Splat293 = ( ( ( 1.0 - CliffSplat284 ) * saturate( ( ( ase_worldPos.y - temp_output_1_0_g741 ) / ( ( temp_output_1_0_g740 + temp_output_9_0_g740 ) - temp_output_1_0_g741 ) ) ) ) * DefaultLayer318 );
			v.vertex.xyz += ( _SnowHeight * Level4Splat293 * float3(0,1,0) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult261 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 UVCoordinate259 = appendResult261;
			float3 ase_worldNormal = i.worldNormal;
			float temp_output_22_0_g686 = cos( ( _CliffthresholdDeg * 0.01745328 ) );
			float temp_output_20_0_g686 = ( 0.01745328 * _Cliffblend );
			float temp_output_1_0_g687 = ( temp_output_22_0_g686 + temp_output_20_0_g686 );
			float CliffSplat284 = saturate( ( ( ase_worldNormal.y - temp_output_1_0_g687 ) / ( ( temp_output_22_0_g686 - temp_output_20_0_g686 ) - temp_output_1_0_g687 ) ) );
			float temp_output_1_0_g740 = ( _Height34 + 0.0 );
			float temp_output_9_0_g740 = _Blend34;
			float temp_output_1_0_g741 = ( temp_output_1_0_g740 - temp_output_9_0_g740 );
			float2 uv_Control = i.uv_texcoord * _Control_ST.xy + _Control_ST.zw;
			float4 tex2DNode317 = SAMPLE_TEXTURE2D( _Control, sampler_Control, uv_Control );
			float DefaultLayer318 = tex2DNode317.r;
			float Level4Splat293 = ( ( ( 1.0 - CliffSplat284 ) * saturate( ( ( ase_worldPos.y - temp_output_1_0_g741 ) / ( ( temp_output_1_0_g740 + temp_output_9_0_g740 ) - temp_output_1_0_g741 ) ) ) ) * DefaultLayer318 );
			float temp_output_23_0_g742 = 0.0;
			float temp_output_1_0_g744 = ( _Height34 + temp_output_23_0_g742 );
			float temp_output_9_0_g744 = _Blend34;
			float temp_output_1_0_g745 = ( temp_output_1_0_g744 + temp_output_9_0_g744 );
			float temp_output_1_0_g746 = ( temp_output_23_0_g742 + _Height23 );
			float temp_output_9_0_g746 = _Blend23;
			float temp_output_1_0_g747 = ( temp_output_1_0_g746 + temp_output_9_0_g746 );
			float Level3Splat294 = ( ( ( 1.0 - CliffSplat284 ) * ( saturate( ( ( ase_worldPos.y - temp_output_1_0_g745 ) / ( ( temp_output_1_0_g744 - temp_output_9_0_g744 ) - temp_output_1_0_g745 ) ) ) - saturate( ( ( ase_worldPos.y - temp_output_1_0_g747 ) / ( ( temp_output_1_0_g746 - temp_output_9_0_g746 ) - temp_output_1_0_g747 ) ) ) ) ) * DefaultLayer318 );
			float temp_output_23_0_g748 = 0.0;
			float temp_output_1_0_g750 = ( _Height23 + temp_output_23_0_g748 );
			float temp_output_9_0_g750 = _Blend23;
			float temp_output_1_0_g751 = ( temp_output_1_0_g750 + temp_output_9_0_g750 );
			float temp_output_1_0_g752 = ( temp_output_23_0_g748 + _Height12 );
			float temp_output_9_0_g752 = _Blend12;
			float temp_output_1_0_g753 = ( temp_output_1_0_g752 + temp_output_9_0_g752 );
			float Level2Splat295 = ( ( ( 1.0 - CliffSplat284 ) * ( saturate( ( ( ase_worldPos.y - temp_output_1_0_g751 ) / ( ( temp_output_1_0_g750 - temp_output_9_0_g750 ) - temp_output_1_0_g751 ) ) ) - saturate( ( ( ase_worldPos.y - temp_output_1_0_g753 ) / ( ( temp_output_1_0_g752 - temp_output_9_0_g752 ) - temp_output_1_0_g753 ) ) ) ) ) * DefaultLayer318 );
			float temp_output_1_0_g737 = ( 0.0 + _Height12 );
			float temp_output_9_0_g737 = _Blend12;
			float temp_output_1_0_g738 = ( temp_output_1_0_g737 + temp_output_9_0_g737 );
			float Level1Splat296 = ( ( ( 1.0 - CliffSplat284 ) * saturate( ( ( ase_worldPos.y - temp_output_1_0_g738 ) / ( ( temp_output_1_0_g737 - temp_output_9_0_g737 ) - temp_output_1_0_g738 ) ) ) ) * DefaultLayer318 );
			float2 uv_Splat1 = i.uv_texcoord * _Splat1_ST.xy + _Splat1_ST.zw;
			float PaintLayer1319 = tex2DNode317.g;
			float2 uv_Splat2 = i.uv_texcoord * _Splat2_ST.xy + _Splat2_ST.zw;
			float PaintLayer2320 = tex2DNode317.b;
			float2 uv_Splat3 = i.uv_texcoord * _Splat3_ST.xy + _Splat3_ST.zw;
			float PaintLayer3321 = tex2DNode317.a;
			float4 localClipHoles39 = ( ( ( ( SAMPLE_TEXTURE2D( __Clifftexture, sampler__Clifftexture, ( ( UVCoordinate259 * __Clifftexture_ST.xy ) + __Clifftexture_ST.zw ) ) * CliffSplat284 ) + ( SAMPLE_TEXTURE2D( _Texture4, sampler_Texture4, ( ( UVCoordinate259 * _Texture4_ST.xy ) + _Texture4_ST.zw ) ) * Level4Splat293 ) + ( SAMPLE_TEXTURE2D( _Texture3, sampler_Texture3, ( ( UVCoordinate259 * _Texture3_ST.xy ) + _Texture3_ST.zw ) ) * Level3Splat294 ) + ( SAMPLE_TEXTURE2D( _Texture2, sampler_Texture2, ( ( UVCoordinate259 * _Texture2_ST.xy ) + _Texture2_ST.zw ) ) * Level2Splat295 ) + ( SAMPLE_TEXTURE2D( _Texture1, sampler_Texture1, ( ( UVCoordinate259 * _Texture1_ST.xy ) + _Texture1_ST.zw ) ) * Level1Splat296 ) ) + ( ( SAMPLE_TEXTURE2D( _Splat1, sampler_Splat1, uv_Splat1 ) * PaintLayer1319 ) + ( SAMPLE_TEXTURE2D( _Splat2, sampler_Splat2, uv_Splat2 ) * PaintLayer2320 ) + ( SAMPLE_TEXTURE2D( _Splat3, sampler_Splat3, uv_Splat3 ) * PaintLayer3321 ) ) ) );
			float2 uv_TerrainHolesTexture = i.uv_texcoord * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
			float Hole39 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture ).r;
			{
			#ifdef _ALPHATEST_ON
				clip(Hole39 == 0.0f ? -1 : 1);
			#endif
			}
			o.Albedo = localClipHoles39.rgb;
			float temp_output_215_0 = 0.0;
			o.Metallic = temp_output_215_0;
			o.Smoothness = temp_output_215_0;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				surfIN.uv_texcoord = IN.customPack1.xy;
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
		UsePass "Hidden/Nature/Terrain/Utilities/PICKING"
		UsePass "Hidden/Nature/Terrain/Utilities/SELECTION"
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18935
295;164;1186;715;-740.1396;-598.5414;5.920427;True;False
Node;AmplifyShaderEditor.CommentaryNode;314;870.4138,710.9299;Inherit;False;946.4196;381.6798;Steepness splat;3;145;143;284;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;145;906.7183,833.7775;Inherit;False;Property;_CliffthresholdDeg;Cliff threshold Deg;16;0;Create;True;0;0;0;False;0;False;45;0.688;0;90;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;908.267,910.4597;Inherit;False;Property;_Cliffblend;Cliff blend;17;0;Create;True;0;0;0;False;0;False;5;0.041;0.0001;25;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;298;-289.8094,1192.02;Inherit;False;946.4196;381.6798;UV map;5;259;273;274;260;261;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;379;1236.805,871.9225;Inherit;False;TerrainSteepnessSplat;-1;;686;8c055b56f2a280245ae7d5a697601bd0;0;2;9;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;260;-227.651,1276.365;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;236;805.8594,1173.502;Inherit;False;2494.983;1055.474;Splatmap Height;26;293;294;295;296;286;285;282;290;292;288;287;289;291;279;278;277;88;87;86;17;20;21;326;327;328;330;;1,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;343;1877.549,711.0834;Inherit;False;594.0095;373.8331;Layer inputs;5;319;320;321;318;317;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;317;1910.27,793.8005;Inherit;True;Property;_Control;Control;4;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;237;3502.515,995.5836;Inherit;False;1792.314;1372.709;Texture assignment;40;301;300;302;303;304;175;309;305;307;308;306;176;179;177;178;409;406;383;401;396;400;382;395;405;408;299;393;272;394;398;404;380;399;403;410;392;402;411;397;407;;0,1,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;284;1565.777,871.3554;Inherit;False;CliffSplat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;261;20.95304,1300.804;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;20;857.1243,1705.986;Inherit;False;Property;_Height23;Height 2-3;8;0;Create;True;0;0;0;False;0;False;15;23.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;858.5262,1991.549;Inherit;False;Property;_Height12;Height 1-2;11;0;Create;True;0;0;0;False;0;False;2;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;866.8585,1789.349;Inherit;False;Property;_Blend23;Blend 2-3;9;0;Create;True;0;0;0;False;0;False;1;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;863.5893,2073.025;Inherit;False;Property;_Blend12;Blend 1-2;12;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;869.4251,1467.225;Inherit;False;Property;_Height34;Height 3-4;1;0;Create;True;0;0;0;False;0;False;35;70;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;876.9944,1547.338;Inherit;False;Property;_Blend34;Blend 3-4;2;0;Create;True;0;0;0;False;0;False;1;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;279;1298.862,2081.012;Inherit;False;TerrainHeightToSplatBottom;-1;;736;2c6309721afd4e747a528bf7483f5d16;0;3;4;FLOAT;0;False;5;FLOAT;0;False;17;FLOAT;0;False;1;FLOAT;10
Node;AmplifyShaderEditor.GetLocalVarNode;285;1403.979,1283.332;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;318;2281.497,756.435;Inherit;False;DefaultLayer;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;278;1305.686,1845.797;Inherit;False;TerrainHeightToSplatMiddle;-1;;748;83724a7e3c36a4a489f9cbbe3da25c42;0;5;14;FLOAT;0;False;11;FLOAT;0;False;12;FLOAT;0;False;23;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;277;1305.636,1606.5;Inherit;False;TerrainHeightToSplatMiddle;-1;;742;83724a7e3c36a4a489f9cbbe3da25c42;0;5;14;FLOAT;0;False;11;FLOAT;0;False;12;FLOAT;0;False;23;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;287;1404.423,1531.28;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;289;1407.604,1772.736;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;392;3576.809,1313.129;Inherit;True;Property;_Texture4;Texture4;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;259;419.9039,1287.716;Inherit;False;UVCoordinate;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;291;1410.516,2013.023;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;402;3578.598,1848.413;Inherit;True;Property;_Texture2;Texture2;10;0;Create;False;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;411;3565.659,1043.395;Inherit;True;Property;__Clifftexture;Clifftexture;15;0;Create;False;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;397;3572.138,1575.323;Inherit;True;Property;_Texture3;Texture3;7;0;Create;False;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;407;3568.731,2098.756;Inherit;True;Property;_Texture1;Texture1;13;0;Create;False;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;282;1321.861,1388.525;Inherit;False;TerrainHeightToSplatTop;-1;;739;66045d6e1f6978145ba9fcbdc1decb72;0;3;4;FLOAT;0;False;5;FLOAT;0;False;19;FLOAT;0;False;1;FLOAT;10
Node;AmplifyShaderEditor.GetLocalVarNode;328;2067.6,1640.508;Inherit;False;318;DefaultLayer;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;299;3885.779,1405.432;Inherit;False;259;UVCoordinate;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;330;2085.8,2105.908;Inherit;False;318;DefaultLayer;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;288;1708.856,1571.589;Inherit;False;TerrainCombineLevelAndSteepnessSplat;-1;;754;6f98bedd32a6e404dbb05d96831fad96;0;2;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;12
Node;AmplifyShaderEditor.GetLocalVarNode;327;2065.001,1439.009;Inherit;False;318;DefaultLayer;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;329;2092.3,1883.608;Inherit;False;318;DefaultLayer;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;292;1714.949,2032.945;Inherit;False;TerrainCombineLevelAndSteepnessSplat;-1;;756;6f98bedd32a6e404dbb05d96831fad96;0;2;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;12
Node;AmplifyShaderEditor.FunctionNode;286;1710.996,1335.797;Inherit;False;TerrainCombineLevelAndSteepnessSplat;-1;;757;6f98bedd32a6e404dbb05d96831fad96;0;2;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;12
Node;AmplifyShaderEditor.FunctionNode;290;1712.037,1813.045;Inherit;False;TerrainCombineLevelAndSteepnessSplat;-1;;755;6f98bedd32a6e404dbb05d96831fad96;0;2;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;12
Node;AmplifyShaderEditor.GetLocalVarNode;272;3874.871,1660.578;Inherit;False;259;UVCoordinate;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;394;3879.688,1742.907;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.GetLocalVarNode;398;3892.432,1919.449;Inherit;False;259;UVCoordinate;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;380;3874.336,1479.641;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureTransformNode;399;3897.249,2001.777;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.GetLocalVarNode;403;3882.565,2169.792;Inherit;False;259;UVCoordinate;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;410;3887.369,1191.021;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.GetLocalVarNode;393;3903.992,1105.836;Inherit;False;259;UVCoordinate;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;404;3875.869,2253.765;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;395;4151.69,1678.907;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;323;2327.61,1334.05;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;324;2347.764,1577.233;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;325;2328.954,1813.699;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;405;4159.385,2188.121;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;382;4144.946,1415.641;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;408;4153.128,1139.738;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;400;4169.251,1937.778;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;326;2331.642,2027.324;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;383;4304.948,1479.641;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;396;4311.692,1742.907;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;296;2757.775,2023.36;Inherit;False;Level1Splat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;409;4321.276,1184.956;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;406;4319.38,2252.12;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;319;2280.497,845.435;Inherit;False;PaintLayer1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;294;2763.375,1566.92;Inherit;False;Level3Splat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;401;4329.25,2001.777;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;342;3521.434,2463.522;Inherit;False;1550.128;751.0048;Layer assignment;9;340;335;337;336;331;338;339;353;352;;0,1,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;321;2274.497,1012.435;Inherit;False;PaintLayer3;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;320;2273.497,932.435;Inherit;False;PaintLayer2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;293;2766.395,1323.612;Inherit;False;Level4Splat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;295;2763.556,1800.92;Inherit;False;Level2Splat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;353;3734.657,3013.664;Inherit;True;Property;_Splat3;Splat3;3;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;175;4516.206,1320.546;Inherit;True;Property;;;0;0;Create;False;0;0;0;False;0;False;-1;None;1d36785a45a4e30459e65366589a47c0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;339;4211.362,3106.076;Inherit;False;321;PaintLayer3;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;309;4887.999,1222.721;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;305;4880.155,2242.731;Inherit;False;296;Level1Splat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;351;3744.312,2530.312;Inherit;True;Property;_Splat1;Splat1;6;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;331;4198.906,2875.885;Inherit;False;320;PaintLayer2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;307;4851.498,1696.507;Inherit;False;294;Level3Splat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;306;4883.493,1978.802;Inherit;False;295;Level2Splat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;176;4510.846,1579.405;Inherit;True;Property;d;s;30;0;Create;False;0;0;0;False;0;False;-1;None;9f762073d021f7043b3ed17ab74cd19e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;179;4495.926,1041.641;Inherit;True;Property;a1;a;39;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;177;4515.405,1850.639;Inherit;True;Property;s;s;34;0;Create;False;0;0;0;False;0;False;-1;None;e0c0f250770eef24994a6a31d68c5f67;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;178;4515.559,2101.193;Inherit;True;Property;a;a;37;0;Create;False;0;0;0;False;0;False;-1;None;c1f47f585d1f89143a2288b5b6fa803c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;308;4865.347,1458.013;Inherit;False;293;Level4Splat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;352;3743.213,2754.628;Inherit;True;Property;_Splat2;Splat2;5;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;338;4189.155,2618.356;Inherit;False;319;PaintLayer1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;301;5145.044,1456.36;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;4421.786,2559.245;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;337;4455.335,3042.375;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;336;4440.239,2820.94;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;302;5158.658,1683.089;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;5151.07,2205.49;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;300;5153.19,1185.289;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;303;5152.568,1953.236;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;238;6036.541,1974.988;Inherit;False;574.3281;352.3896;Clip holes;2;41;39;;0,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;310;5551.877,1508.09;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;340;4930.395,2730.767;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;354;6137.306,2487.012;Inherit;False;Property;_SnowHeight;SnowHeight;20;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;239;6634.392,1980.894;Inherit;False;509.3618;489.544;Assign;2;0;215;;0,0,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;358;6130.826,2647.82;Inherit;False;Constant;_Vector0;Vector 0;21;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;235;-427.7214,1772.033;Inherit;False;1121.118;439.5583;Layer height noise;8;275;230;226;227;234;232;233;228;;1,0,0,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;356;6112.826,2568.82;Inherit;False;293;Level4Splat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;341;5902.145,2038.281;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;41;6072.935,2122.774;Inherit;True;Property;_TerrainHolesTexture;_TerrainHolesTexture;14;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;215;6706.745,2102.006;Inherit;False;Constant;_Float10;Float 10;22;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;227;-65.90945,1829.759;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;274;12.86652,1454.508;Inherit;False;Constant;_Float0;Float 0;16;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;275;492.9918,1957.873;Inherit;False;Layerheightnoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-415.5994,2015.83;Inherit;False;Property;_Noisescale;Noise scale;19;0;Create;True;0;0;0;False;0;False;0.5;0.023;0.023;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;226;229.3906,1958.718;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;273;217.1479,1365.867;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;233;-318.1663,1927.196;Inherit;False;Constant;_Float11;Float 11;28;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;230;-417.6175,2115.363;Inherit;False;Property;_Noiseheight;Noise height;18;0;Create;True;0;0;0;False;0;False;0;2.9;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;39;6450.17,2045.013;Inherit;False;#ifdef _ALPHATEST_ON$	clip(Hole == 0.0f ? -1 : 1)@$#endif;1;Call;1;True;Hole;FLOAT;0;In;;Inherit;False;ClipHoles;False;False;0;;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;357;6412.826,2513.82;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ExpOpNode;234;59.99806,1979.107;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;232;-91.16628,1971.195;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;6902.049,2020.726;Float;False;True;-1;2;;0;0;Standard;iffnsShaders/WorldTools/AutoTexture/AutoTerrainTexture;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;True;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;379;9;145;0
WireConnection;379;10;143;0
WireConnection;284;0;379;0
WireConnection;261;0;260;1
WireConnection;261;1;260;3
WireConnection;279;4;17;0
WireConnection;279;5;88;0
WireConnection;318;0;317;1
WireConnection;278;14;20;0
WireConnection;278;11;87;0
WireConnection;278;12;17;0
WireConnection;278;13;88;0
WireConnection;277;14;21;0
WireConnection;277;11;86;0
WireConnection;277;12;20;0
WireConnection;277;13;87;0
WireConnection;259;0;261;0
WireConnection;282;4;21;0
WireConnection;282;5;86;0
WireConnection;288;5;287;0
WireConnection;288;6;277;0
WireConnection;292;5;291;0
WireConnection;292;6;279;10
WireConnection;286;5;285;0
WireConnection;286;6;282;10
WireConnection;290;5;289;0
WireConnection;290;6;278;0
WireConnection;394;0;397;0
WireConnection;380;0;392;0
WireConnection;399;0;402;0
WireConnection;410;0;411;0
WireConnection;404;0;407;0
WireConnection;395;0;272;0
WireConnection;395;1;394;0
WireConnection;323;0;286;12
WireConnection;323;1;327;0
WireConnection;324;0;288;12
WireConnection;324;1;328;0
WireConnection;325;0;290;12
WireConnection;325;1;329;0
WireConnection;405;0;403;0
WireConnection;405;1;404;0
WireConnection;382;0;299;0
WireConnection;382;1;380;0
WireConnection;408;0;393;0
WireConnection;408;1;410;0
WireConnection;400;0;398;0
WireConnection;400;1;399;0
WireConnection;326;0;292;12
WireConnection;326;1;330;0
WireConnection;383;0;382;0
WireConnection;383;1;380;1
WireConnection;396;0;395;0
WireConnection;396;1;394;1
WireConnection;296;0;326;0
WireConnection;409;0;408;0
WireConnection;409;1;410;1
WireConnection;406;0;405;0
WireConnection;406;1;404;1
WireConnection;319;0;317;2
WireConnection;294;0;324;0
WireConnection;401;0;400;0
WireConnection;401;1;399;1
WireConnection;321;0;317;4
WireConnection;320;0;317;3
WireConnection;293;0;323;0
WireConnection;295;0;325;0
WireConnection;175;0;392;0
WireConnection;175;1;383;0
WireConnection;176;0;397;0
WireConnection;176;1;396;0
WireConnection;179;0;411;0
WireConnection;179;1;409;0
WireConnection;177;0;402;0
WireConnection;177;1;401;0
WireConnection;178;0;407;0
WireConnection;178;1;406;0
WireConnection;301;0;175;0
WireConnection;301;1;308;0
WireConnection;335;0;351;0
WireConnection;335;1;338;0
WireConnection;337;0;353;0
WireConnection;337;1;339;0
WireConnection;336;0;352;0
WireConnection;336;1;331;0
WireConnection;302;0;176;0
WireConnection;302;1;307;0
WireConnection;304;0;178;0
WireConnection;304;1;305;0
WireConnection;300;0;179;0
WireConnection;300;1;309;0
WireConnection;303;0;177;0
WireConnection;303;1;306;0
WireConnection;310;0;300;0
WireConnection;310;1;301;0
WireConnection;310;2;302;0
WireConnection;310;3;303;0
WireConnection;310;4;304;0
WireConnection;340;0;335;0
WireConnection;340;1;336;0
WireConnection;340;2;337;0
WireConnection;341;0;310;0
WireConnection;341;1;340;0
WireConnection;275;0;226;0
WireConnection;226;0;227;0
WireConnection;226;1;234;0
WireConnection;273;0;261;0
WireConnection;273;2;274;0
WireConnection;39;0;341;0
WireConnection;39;1;41;1
WireConnection;357;0;354;0
WireConnection;357;1;356;0
WireConnection;357;2;358;0
WireConnection;234;0;232;0
WireConnection;232;0;233;0
WireConnection;232;1;228;0
WireConnection;0;0;39;0
WireConnection;0;3;215;0
WireConnection;0;4;215;0
WireConnection;0;11;357;0
ASEEND*/
//CHKSM=E5D6F77A2EEE47A95754C1C24C8B2A2EDCDCC04F