// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "iffnsShaders/WorldTools/AutoTexture/AutoTerrainTexture"
{
	Properties
	{
		[HideInInspector]_TerrainHolesTexture("_TerrainHolesTexture", 2D) = "white" {}
		[HideInInspector]_Splat3("Splat3", 2D) = "white" {}
		[HideInInspector]_Splat2("Splat2", 2D) = "white" {}
		[HideInInspector]_Splat1("Splat1", 2D) = "white" {}
		[HideInInspector]_Splat0("Splat0", 2D) = "white" {}
		[HideInInspector]_Smoothness3("Smoothness3", Range( 0 , 1)) = 1
		[HideInInspector]_Smoothness1("Smoothness1", Range( 0 , 1)) = 1
		[HideInInspector]_Smoothness0("Smoothness0", Range( 0 , 1)) = 1
		[HideInInspector]_Smoothness2("Smoothness2", Range( 0 , 1)) = 1
		[HideInInspector]_Mask2("_Mask2", 2D) = "white" {}
		[HideInInspector]_Mask0("_Mask0", 2D) = "white" {}
		[HideInInspector]_Mask1("_Mask1", 2D) = "white" {}
		[HideInInspector]_Mask3("_Mask3", 2D) = "white" {}
		_SnowTexture("SnowTexture", 2D) = "white" {}
		_SnowHeight("SnowHeight", Float) = 35
		_SnowBlend("SnowBlend", Float) = 1
		[HideInInspector]_Control("Control", 2D) = "white" {}
		_Texture3("Texture3", 2D) = "white" {}
		_Height23("Height 2-3", Float) = 15
		_Blend23("Blend 2-3", Float) = 1
		_Texture2("Texture2", 2D) = "white" {}
		_Height12("Height 1-2", Float) = 2
		_Blend12("Blend 1-2", Float) = 1
		_Texture1("Texture1", 2D) = "white" {}
		__Clifftexture("Clifftexture", 2D) = "white" {}
		_CliffthresholdDeg("Cliff threshold Deg", Range( 0 , 90)) = 45
		_Cliffblend("Cliff blend", Range( 0.0001 , 25)) = 5
		_SnowDepth("SnowDepth", Float) = 0
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
		#pragma multi_compile_local __ _ALPHATEST_ON
		#pragma shader_feature_local _MASKMAP
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex.SampleLevel(samplerTex,coord, lod)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex2Dlod(tex,float4(coord,0,lod))
		#endif//ASE Sampling Macros

		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
		};

		UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask2);
		SamplerState sampler_Mask2;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask1);
		SamplerState sampler_Mask1;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask0);
		SamplerState sampler_Mask0;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask3);
		SamplerState sampler_Mask3;
		uniform float4 _MaskMapRemapScale0;
		uniform float4 _MaskMapRemapOffset2;
		uniform float4 _MaskMapRemapScale1;
		uniform float4 _MaskMapRemapScale2;
		uniform float4 _MaskMapRemapOffset1;
		uniform float4 _MaskMapRemapScale3;
		uniform float4 _MaskMapRemapOffset3;
		uniform float4 _MaskMapRemapOffset0;
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
		uniform float _SnowDepth;
		uniform float _CliffthresholdDeg;
		uniform float _Cliffblend;
		uniform float _SnowHeight;
		uniform float _SnowBlend;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Control);
		uniform float4 _Control_ST;
		SamplerState sampler_Control;
		UNITY_DECLARE_TEX2D_NOSAMPLER(__Clifftexture);
		uniform float4 __Clifftexture_ST;
		SamplerState sampler__Clifftexture;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_SnowTexture);
		uniform float4 _SnowTexture_ST;
		SamplerState sampler_SnowTexture;
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
		uniform float _Smoothness0;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat0);
		uniform float4 _Splat0_ST;
		SamplerState sampler_Splat0;
		uniform float _Smoothness1;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat1);
		uniform float4 _Splat1_ST;
		SamplerState sampler_Splat1;
		uniform float _Smoothness2;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat2);
		uniform float4 _Splat2_ST;
		SamplerState sampler_Splat2;
		uniform float _Smoothness3;
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
			float temp_output_1_0_g926 = ( _SnowHeight + 0.0 );
			float temp_output_9_0_g926 = _SnowBlend;
			float temp_output_1_0_g927 = ( temp_output_1_0_g926 - temp_output_9_0_g926 );
			float temp_output_463_12 = ( ( 1.0 - CliffSplat284 ) * saturate( ( ( ase_worldPos.y - temp_output_1_0_g927 ) / ( ( temp_output_1_0_g926 + temp_output_9_0_g926 ) - temp_output_1_0_g927 ) ) ) );
			float SnowSplat465 = temp_output_463_12;
			float2 uv_Control = v.texcoord * _Control_ST.xy + _Control_ST.zw;
			float4 tex2DNode506 = SAMPLE_TEXTURE2D_LOD( _Control, sampler_Control, uv_Control, 0.0 );
			float AutoTextureSplat516 = tex2DNode506.r;
			v.vertex.xyz += ( _SnowDepth * SnowSplat465 * AutoTextureSplat516 * float3(0,1,0) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldPos = i.worldPos;
			float2 appendResult261 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 UVCoordinate259 = appendResult261;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float temp_output_22_0_g686 = cos( ( _CliffthresholdDeg * 0.01745328 ) );
			float temp_output_20_0_g686 = ( 0.01745328 * _Cliffblend );
			float temp_output_1_0_g687 = ( temp_output_22_0_g686 + temp_output_20_0_g686 );
			float CliffSplat284 = saturate( ( ( ase_worldNormal.y - temp_output_1_0_g687 ) / ( ( temp_output_22_0_g686 - temp_output_20_0_g686 ) - temp_output_1_0_g687 ) ) );
			float temp_output_1_0_g926 = ( _SnowHeight + 0.0 );
			float temp_output_9_0_g926 = _SnowBlend;
			float temp_output_1_0_g927 = ( temp_output_1_0_g926 - temp_output_9_0_g926 );
			float temp_output_463_12 = ( ( 1.0 - CliffSplat284 ) * saturate( ( ( ase_worldPos.y - temp_output_1_0_g927 ) / ( ( temp_output_1_0_g926 + temp_output_9_0_g926 ) - temp_output_1_0_g927 ) ) ) );
			float SnowSplat465 = temp_output_463_12;
			float temp_output_1_0_g940 = ( _Height23 + 0.0 );
			float temp_output_9_0_g940 = _Blend23;
			float temp_output_1_0_g941 = ( temp_output_1_0_g940 - temp_output_9_0_g940 );
			float InvertedSnowSplat468 = ( 1.0 - temp_output_463_12 );
			float Level3Splat293 = ( ( ( 1.0 - CliffSplat284 ) * saturate( ( ( ase_worldPos.y - temp_output_1_0_g941 ) / ( ( temp_output_1_0_g940 + temp_output_9_0_g940 ) - temp_output_1_0_g941 ) ) ) ) * InvertedSnowSplat468 );
			float temp_output_23_0_g942 = 0.0;
			float temp_output_1_0_g944 = ( _Height23 + temp_output_23_0_g942 );
			float temp_output_9_0_g944 = _Blend23;
			float temp_output_1_0_g945 = ( temp_output_1_0_g944 + temp_output_9_0_g944 );
			float temp_output_1_0_g946 = ( temp_output_23_0_g942 + _Height12 );
			float temp_output_9_0_g946 = _Blend12;
			float temp_output_1_0_g947 = ( temp_output_1_0_g946 + temp_output_9_0_g946 );
			float Level2Splat295 = ( ( ( 1.0 - CliffSplat284 ) * ( saturate( ( ( ase_worldPos.y - temp_output_1_0_g945 ) / ( ( temp_output_1_0_g944 - temp_output_9_0_g944 ) - temp_output_1_0_g945 ) ) ) - saturate( ( ( ase_worldPos.y - temp_output_1_0_g947 ) / ( ( temp_output_1_0_g946 - temp_output_9_0_g946 ) - temp_output_1_0_g947 ) ) ) ) ) * InvertedSnowSplat468 );
			float temp_output_1_0_g930 = ( 0.0 + _Height12 );
			float temp_output_9_0_g930 = _Blend12;
			float temp_output_1_0_g931 = ( temp_output_1_0_g930 + temp_output_9_0_g930 );
			float Level1Splat296 = ( ( ( 1.0 - CliffSplat284 ) * saturate( ( ( ase_worldPos.y - temp_output_1_0_g931 ) / ( ( temp_output_1_0_g930 - temp_output_9_0_g930 ) - temp_output_1_0_g931 ) ) ) ) * InvertedSnowSplat468 );
			float4 AutoAlbedo459 = ( ( SAMPLE_TEXTURE2D( __Clifftexture, sampler__Clifftexture, ( ( UVCoordinate259 * __Clifftexture_ST.xy ) + __Clifftexture_ST.zw ) ) * CliffSplat284 ) + ( SAMPLE_TEXTURE2D( _SnowTexture, sampler_SnowTexture, ( ( UVCoordinate259 * _SnowTexture_ST.xy ) + _SnowTexture_ST.zw ) ) * SnowSplat465 ) + ( SAMPLE_TEXTURE2D( _Texture3, sampler_Texture3, ( ( UVCoordinate259 * _Texture3_ST.xy ) + _Texture3_ST.zw ) ) * Level3Splat293 ) + ( SAMPLE_TEXTURE2D( _Texture2, sampler_Texture2, ( ( UVCoordinate259 * _Texture2_ST.xy ) + _Texture2_ST.zw ) ) * Level2Splat295 ) + ( SAMPLE_TEXTURE2D( _Texture1, sampler_Texture1, ( ( UVCoordinate259 * _Texture1_ST.xy ) + _Texture1_ST.zw ) ) * Level1Splat296 ) );
			float2 uv_Control = i.uv_texcoord * _Control_ST.xy + _Control_ST.zw;
			float4 tex2DNode506 = SAMPLE_TEXTURE2D( _Control, sampler_Control, uv_Control );
			float4 tex2DNode5_g951 = SAMPLE_TEXTURE2D( _Control, sampler_Control, uv_Control );
			float dotResult20_g951 = dot( tex2DNode5_g951 , float4(1,1,1,1) );
			float SplatWeight22_g951 = dotResult20_g951;
			float localSplatClip74_g951 = ( SplatWeight22_g951 );
			float SplatWeight74_g951 = SplatWeight22_g951;
			{
			#if !defined(SHADER_API_MOBILE) && defined(TERRAIN_SPLAT_ADDPASS)
				clip(SplatWeight74_g951 == 0.0f ? -1 : 1);
			#endif
			}
			float4 SplatControl26_g951 = ( tex2DNode5_g951 / ( localSplatClip74_g951 + 0.001 ) );
			float4 temp_output_59_0_g951 = SplatControl26_g951;
			float4 appendResult33_g951 = (float4(1.0 , 1.0 , 1.0 , _Smoothness0));
			float2 uv_Splat0 = i.uv_texcoord * _Splat0_ST.xy + _Splat0_ST.zw;
			float4 tex2DNode4_g951 = SAMPLE_TEXTURE2D( _Splat0, sampler_Splat0, uv_Splat0 );
			float3 _Vector1 = float3(1,1,1);
			float4 appendResult258_g951 = (float4(_Vector1 , 1.0));
			float4 tintLayer0253_g951 = appendResult258_g951;
			float4 appendResult36_g951 = (float4(1.0 , 1.0 , 1.0 , _Smoothness1));
			float2 uv_Splat1 = i.uv_texcoord * _Splat1_ST.xy + _Splat1_ST.zw;
			float4 tex2DNode3_g951 = SAMPLE_TEXTURE2D( _Splat1, sampler_Splat1, uv_Splat1 );
			float3 _Vector2 = float3(1,1,1);
			float4 appendResult261_g951 = (float4(_Vector2 , 1.0));
			float4 tintLayer1254_g951 = appendResult261_g951;
			float4 appendResult39_g951 = (float4(1.0 , 1.0 , 1.0 , _Smoothness2));
			float2 uv_Splat2 = i.uv_texcoord * _Splat2_ST.xy + _Splat2_ST.zw;
			float4 tex2DNode6_g951 = SAMPLE_TEXTURE2D( _Splat2, sampler_Splat2, uv_Splat2 );
			float3 _Vector3 = float3(1,1,1);
			float4 appendResult263_g951 = (float4(_Vector3 , 1.0));
			float4 tintLayer2255_g951 = appendResult263_g951;
			float4 appendResult42_g951 = (float4(1.0 , 1.0 , 1.0 , _Smoothness3));
			float2 uv_Splat3 = i.uv_texcoord * _Splat3_ST.xy + _Splat3_ST.zw;
			float4 tex2DNode7_g951 = SAMPLE_TEXTURE2D( _Splat3, sampler_Splat3, uv_Splat3 );
			float3 _Vector4 = float3(1,1,1);
			float4 appendResult265_g951 = (float4(_Vector4 , 1.0));
			float4 tintLayer3256_g951 = appendResult265_g951;
			float4 weightedBlendVar9_g951 = temp_output_59_0_g951;
			float4 weightedBlend9_g951 = ( weightedBlendVar9_g951.x*( appendResult33_g951 * tex2DNode4_g951 * tintLayer0253_g951 ) + weightedBlendVar9_g951.y*( appendResult36_g951 * tex2DNode3_g951 * tintLayer1254_g951 ) + weightedBlendVar9_g951.z*( appendResult39_g951 * tex2DNode6_g951 * tintLayer2255_g951 ) + weightedBlendVar9_g951.w*( appendResult42_g951 * tex2DNode7_g951 * tintLayer3256_g951 ) );
			float4 MixDiffuse28_g951 = weightedBlend9_g951;
			float4 temp_output_60_0_g951 = MixDiffuse28_g951;
			float4 localClipHoles100_g951 = ( temp_output_60_0_g951 );
			float2 uv_TerrainHolesTexture = i.uv_texcoord * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
			float holeClipValue99_g951 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture ).r;
			float Hole100_g951 = holeClipValue99_g951;
			{
			#ifdef _ALPHATEST_ON
				clip(Hole100_g951 == 0.0f ? -1 : 1);
			#endif
			}
			o.Albedo = ( ( AutoAlbedo459 * tex2DNode506.r ) + ( ( 1.0 - tex2DNode506.r ) * localClipHoles100_g951 ) ).rgb;
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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
	Fallback "Nature/Terrain/Standard"
}
/*ASEBEGIN
Version=18935
465;72;1185;812;-3964.298;-497.0467;2.903524;True;False
Node;AmplifyShaderEditor.CommentaryNode;314;1548.801,486.5404;Inherit;False;946.4196;381.6798;Steepness splat;3;145;143;284;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;143;1586.654,686.0701;Inherit;False;Property;_Cliffblend;Cliff blend;37;0;Create;True;0;0;0;False;0;False;5;2.4;0.0001;25;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;145;1585.105,609.3879;Inherit;False;Property;_CliffthresholdDeg;Cliff threshold Deg;36;0;Create;True;0;0;0;False;0;False;45;45;0;90;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;236;1449.84,920.1381;Inherit;False;1957.734;1043.795;Splatmap Height;30;293;296;295;292;286;290;289;291;279;282;285;278;87;88;20;86;21;17;464;465;463;467;468;470;471;472;473;474;475;469;;1,1,0,1;0;0
Node;AmplifyShaderEditor.FunctionNode;379;1915.192,647.5328;Inherit;False;TerrainSteepnessSplat;-1;;686;8c055b56f2a280245ae7d5a697601bd0;0;2;9;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;1571.496,1211.449;Inherit;False;Property;_SnowBlend;SnowBlend;26;0;Create;True;0;0;0;False;0;False;1;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;1573.97,1138.807;Inherit;False;Property;_SnowHeight;SnowHeight;25;0;Create;True;0;0;0;False;0;False;35;70;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;284;2244.164,646.9658;Inherit;False;CliffSplat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;475;1943.205,1127.389;Inherit;False;TerrainHeightToSplatTop;-1;;925;66045d6e1f6978145ba9fcbdc1decb72;0;3;4;FLOAT;0;False;5;FLOAT;0;False;19;FLOAT;0;False;1;FLOAT;10
Node;AmplifyShaderEditor.GetLocalVarNode;464;2024.732,994.9019;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;298;388.5778,967.6301;Inherit;False;946.4196;381.6798;UV map;3;259;260;261;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;260;450.7362,1051.975;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;463;2307.333,1115.156;Inherit;False;TerrainCombineLevelAndSteepnessSplat;-1;;928;6f98bedd32a6e404dbb05d96831fad96;0;2;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;12
Node;AmplifyShaderEditor.OneMinusNode;467;2747.365,1181.788;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;1507.57,1819.661;Inherit;False;Property;_Blend12;Blend 1-2;33;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;261;699.3402,1076.414;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;20;1501.105,1452.622;Inherit;False;Property;_Height23;Height 2-3;29;0;Create;True;0;0;0;False;0;False;15;23.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;237;3434.786,847.5234;Inherit;False;2609.445;2345.209;Texture assignment;42;459;310;301;300;302;304;303;309;177;178;305;175;306;307;176;308;179;383;406;409;401;396;408;405;395;382;400;380;272;393;404;299;410;398;394;399;407;392;397;411;402;518;;0,0,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;87;1510.84,1535.985;Inherit;False;Property;_Blend23;Blend 2-3;30;0;Create;True;0;0;0;False;0;False;1;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;1502.507,1738.185;Inherit;False;Property;_Height12;Height 1-2;32;0;Create;True;0;0;0;False;0;False;2;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;259;1090.311,1071.306;Inherit;False;UVCoordinate;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;289;2051.584,1519.372;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;407;3612.34,2644.959;Inherit;True;Property;_Texture1;Texture1;34;0;Create;False;0;0;0;False;0;False;None;6e40538a8d0200d47afeb117af441b0e;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;278;1949.666,1592.433;Inherit;False;TerrainHeightToSplatMiddle;-1;;942;83724a7e3c36a4a489f9cbbe3da25c42;0;5;14;FLOAT;0;False;11;FLOAT;0;False;12;FLOAT;0;False;23;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;285;2028.181,1276.121;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;282;1950.841,1366.161;Inherit;False;TerrainHeightToSplatTop;-1;;939;66045d6e1f6978145ba9fcbdc1decb72;0;3;4;FLOAT;0;False;5;FLOAT;0;False;19;FLOAT;0;False;1;FLOAT;10
Node;AmplifyShaderEditor.TexturePropertyNode;402;3621.674,2215.705;Inherit;True;Property;_Texture2;Texture2;31;0;Create;False;0;0;0;False;0;False;None;9ca14f4173869b444a7a92e6d295eaa4;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;291;2054.496,1759.659;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;279;1939.535,1839.224;Inherit;False;TerrainHeightToSplatBottom;-1;;929;2c6309721afd4e747a528bf7483f5d16;0;3;4;FLOAT;0;False;5;FLOAT;0;False;17;FLOAT;0;False;1;FLOAT;10
Node;AmplifyShaderEditor.RegisterLocalVarNode;468;2963.025,1197.951;Inherit;False;InvertedSnowSplat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;397;3613.266,1772.148;Inherit;True;Property;_Texture3;Texture3;28;0;Create;False;0;0;0;False;0;False;None;fca5fab850ea760448ab259d7010d49d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;411;3608.631,920.7906;Inherit;True;Property;__Clifftexture;Clifftexture;35;0;Create;False;0;0;0;False;0;False;None;62df36f05b105a54ea5fc2526d0fc2b1;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;392;3604.174,1356.157;Inherit;True;Property;_SnowTexture;SnowTexture;24;0;Create;True;0;0;0;False;0;False;None;0cb3496584a6199428648799d2212530;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;292;2346.929,1778.581;Inherit;False;TerrainCombineLevelAndSteepnessSplat;-1;;948;6f98bedd32a6e404dbb05d96831fad96;0;2;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;12
Node;AmplifyShaderEditor.FunctionNode;286;2350.36,1329.664;Inherit;False;TerrainCombineLevelAndSteepnessSplat;-1;;950;6f98bedd32a6e404dbb05d96831fad96;0;2;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;12
Node;AmplifyShaderEditor.GetLocalVarNode;398;3927.392,2280.248;Inherit;False;259;UVCoordinate;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;290;2356.017,1559.681;Inherit;False;TerrainCombineLevelAndSteepnessSplat;-1;;949;6f98bedd32a6e404dbb05d96831fad96;0;2;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;12
Node;AmplifyShaderEditor.GetLocalVarNode;473;2472.873,1682.138;Inherit;False;468;InvertedSnowSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;399;3910.996,2364.198;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.GetLocalVarNode;299;3911.144,1423.46;Inherit;False;259;UVCoordinate;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;404;3919.478,2799.968;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.GetLocalVarNode;472;2477.873,1437.138;Inherit;False;468;InvertedSnowSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;393;3945.664,981.8644;Inherit;False;259;UVCoordinate;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;474;2472.873,1881.138;Inherit;False;468;InvertedSnowSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;272;3916,1857.403;Inherit;False;259;UVCoordinate;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;380;3901.701,1512.669;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureTransformNode;394;3920.816,1939.732;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.GetLocalVarNode;518;3938.158,2702.181;Inherit;False;259;UVCoordinate;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;410;3930.341,1068.417;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;408;4196.103,1017.134;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;405;4202.996,2734.324;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;469;2788.873,1334.138;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;382;4172.312,1448.669;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;400;4212.33,2305.07;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;395;4192.821,1875.732;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;470;2784.873,1575.138;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;471;2775.873,1778.138;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;401;4368.971,2369.068;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;296;2965.609,1777.982;Inherit;False;Level1Splat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;396;4352.823,1939.732;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;383;4332.315,1512.669;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;409;4364.251,1062.352;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;293;2978.736,1332.465;Inherit;False;Level3Splat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;295;2971.39,1555.542;Inherit;False;Level2Splat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;465;2968.265,1103.376;Inherit;False;SnowSplat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;406;4362.991,2798.323;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;177;4558.483,2217.931;Inherit;True;Property;s;s;34;0;Create;False;0;0;0;False;0;False;-1;None;e0c0f250770eef24994a6a31d68c5f67;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;175;4543.572,1353.574;Inherit;True;Property;;;0;0;Create;False;0;0;0;False;0;False;-1;None;1d36785a45a4e30459e65366589a47c0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;179;4538.9,919.0366;Inherit;True;Property;a1;a;39;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;306;4926.572,2346.094;Inherit;False;295;Level2Splat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;305;4923.766,2788.934;Inherit;False;296;Level1Splat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;307;4892.629,1892.251;Inherit;False;293;Level3Splat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;176;4551.978,1776.23;Inherit;True;Property;d;s;30;0;Create;False;0;0;0;False;0;False;-1;None;9f762073d021f7043b3ed17ab74cd19e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;178;4558.076,2647.396;Inherit;True;Property;a;a;37;0;Create;False;0;0;0;False;0;False;-1;None;c1f47f585d1f89143a2288b5b6fa803c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;309;4930.974,1100.117;Inherit;False;284;CliffSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;308;4885.253,1512.013;Inherit;False;465;SnowSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;302;5199.79,1879.914;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;5194.681,2751.693;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;303;5195.647,2320.528;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;300;5196.165,1062.685;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;301;5171.14,1465.256;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;476;6092.403,841.3989;Inherit;False;1092.442;2316.754;Combine with terrain textures;8;511;510;508;507;509;505;506;516;;0.4433962,0.4433962,0.4433962,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;310;5590.859,1441.383;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;459;5820.875,1452.704;Inherit;False;AutoAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;506;6134.121,1622.1;Inherit;True;Property;_Control;Control;27;1;[HideInInspector];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;509;6554.257,1717.042;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;505;6137.489,1868.44;Inherit;False;Four Splats First Pass Terrain;0;;951;37452fdfb732e1443b7e39720d05b708;2,102,1,85,0;7;59;FLOAT4;0,0,0,0;False;60;FLOAT4;0,0,0,0;False;61;FLOAT3;0,0,0;False;57;FLOAT;0;False;58;FLOAT;0;False;201;FLOAT;0;False;62;FLOAT;0;False;7;FLOAT4;0;FLOAT3;14;FLOAT;56;FLOAT;45;FLOAT;200;FLOAT;19;FLOAT3;17
Node;AmplifyShaderEditor.GetLocalVarNode;507;6302.738,1428.728;Inherit;False;459;AutoAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;477;7280.54,1614.393;Inherit;False;1049.753;1075.089;Apply to terrain;6;357;358;354;517;356;239;;1,0,0.6931067,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;516;6446.875,1610.144;Inherit;False;AutoTextureSplat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;508;6778.085,1638.375;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;354;7394.629,2116.404;Inherit;False;Property;_SnowDepth;SnowDepth;40;0;Create;True;0;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;239;7741.118,1810.252;Inherit;False;509.3618;489.544;Assign;2;0;215;;0,0,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;510;6779.041,1776.557;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;356;7375.149,2199.212;Inherit;False;465;SnowSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;235;250.6658,1547.643;Inherit;False;1121.118;439.5583;Layer height noise;8;275;230;226;227;234;232;233;228;;1,0,0,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;517;7351.583,2285.799;Inherit;False;516;AutoTextureSplat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;358;7405.149,2363.212;Inherit;False;Constant;_Vector0;Vector 0;21;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;227;612.4777,1605.369;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;511;6971.121,1724.709;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;226;907.7778,1734.328;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;232;587.2209,1746.805;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;357;7672.149,2146.212;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;228;262.7878,1791.44;Inherit;False;Property;_Noisescale;Noise scale;39;0;Create;True;0;0;0;False;0;False;0.5;0.023;0.023;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;230;260.7697,1890.973;Inherit;False;Property;_Noiseheight;Noise height;38;0;Create;True;0;0;0;False;0;False;0;2.9;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;233;360.2209,1702.806;Inherit;False;Constant;_Float11;Float 11;28;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;275;1171.379,1733.483;Inherit;False;Layerheightnoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;215;7792.329,1998.132;Inherit;False;Constant;_Float10;Float 10;22;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ExpOpNode;234;738.3853,1754.717;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;8008.779,1842.029;Float;False;True;-1;2;;0;0;Standard;iffnsShaders/WorldTools/AutoTexture/AutoTerrainTexture;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;Nature/Terrain/Standard;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;True;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;379;9;145;0
WireConnection;379;10;143;0
WireConnection;284;0;379;0
WireConnection;475;4;21;0
WireConnection;475;5;86;0
WireConnection;463;5;464;0
WireConnection;463;6;475;10
WireConnection;467;0;463;12
WireConnection;261;0;260;1
WireConnection;261;1;260;3
WireConnection;259;0;261;0
WireConnection;278;14;20;0
WireConnection;278;11;87;0
WireConnection;278;12;17;0
WireConnection;278;13;88;0
WireConnection;282;4;20;0
WireConnection;282;5;87;0
WireConnection;279;4;17;0
WireConnection;279;5;88;0
WireConnection;468;0;467;0
WireConnection;292;5;291;0
WireConnection;292;6;279;10
WireConnection;286;5;285;0
WireConnection;286;6;282;10
WireConnection;290;5;289;0
WireConnection;290;6;278;0
WireConnection;399;0;402;0
WireConnection;404;0;407;0
WireConnection;380;0;392;0
WireConnection;394;0;397;0
WireConnection;410;0;411;0
WireConnection;408;0;393;0
WireConnection;408;1;410;0
WireConnection;405;0;518;0
WireConnection;405;1;404;0
WireConnection;469;0;286;12
WireConnection;469;1;472;0
WireConnection;382;0;299;0
WireConnection;382;1;380;0
WireConnection;400;0;398;0
WireConnection;400;1;399;0
WireConnection;395;0;272;0
WireConnection;395;1;394;0
WireConnection;470;0;290;12
WireConnection;470;1;473;0
WireConnection;471;0;292;12
WireConnection;471;1;474;0
WireConnection;401;0;400;0
WireConnection;401;1;399;1
WireConnection;296;0;471;0
WireConnection;396;0;395;0
WireConnection;396;1;394;1
WireConnection;383;0;382;0
WireConnection;383;1;380;1
WireConnection;409;0;408;0
WireConnection;409;1;410;1
WireConnection;293;0;469;0
WireConnection;295;0;470;0
WireConnection;465;0;463;12
WireConnection;406;0;405;0
WireConnection;406;1;404;1
WireConnection;177;0;402;0
WireConnection;177;1;401;0
WireConnection;175;0;392;0
WireConnection;175;1;383;0
WireConnection;179;0;411;0
WireConnection;179;1;409;0
WireConnection;176;0;397;0
WireConnection;176;1;396;0
WireConnection;178;0;407;0
WireConnection;178;1;406;0
WireConnection;302;0;176;0
WireConnection;302;1;307;0
WireConnection;304;0;178;0
WireConnection;304;1;305;0
WireConnection;303;0;177;0
WireConnection;303;1;306;0
WireConnection;300;0;179;0
WireConnection;300;1;309;0
WireConnection;301;0;175;0
WireConnection;301;1;308;0
WireConnection;310;0;300;0
WireConnection;310;1;301;0
WireConnection;310;2;302;0
WireConnection;310;3;303;0
WireConnection;310;4;304;0
WireConnection;459;0;310;0
WireConnection;509;0;506;1
WireConnection;516;0;506;1
WireConnection;508;0;507;0
WireConnection;508;1;506;1
WireConnection;510;0;509;0
WireConnection;510;1;505;0
WireConnection;511;0;508;0
WireConnection;511;1;510;0
WireConnection;226;0;227;0
WireConnection;226;1;234;0
WireConnection;232;0;233;0
WireConnection;232;1;228;0
WireConnection;357;0;354;0
WireConnection;357;1;356;0
WireConnection;357;2;517;0
WireConnection;357;3;358;0
WireConnection;275;0;226;0
WireConnection;234;0;232;0
WireConnection;0;0;511;0
WireConnection;0;3;215;0
WireConnection;0;4;215;0
WireConnection;0;11;357;0
ASEEND*/
//CHKSM=EC3451D210148C452F3D325E8530875F9319E8E2