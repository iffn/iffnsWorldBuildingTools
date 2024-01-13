# if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using Unity.VisualScripting;
using System.Data.Common;

public class TerrainHoleTest : EditorWindow
{
    Terrain linkedTerrain;
    MeshFilter linkedMeshFilter;

    [MenuItem("Tools/iffnsStuff/WorldBuildingTools/TerrainHolePuncher")]
    public static void ShowWindow()
    {
        GetWindow(typeof(TerrainHoleTest), false, "Terrain hole puncher");
    }

    Mesh tempMesh;

    void OnGUI()
    {
        GUILayout.Label(text: "Terrain hole puncher", style: EditorStyles.boldLabel);

        linkedTerrain = EditorGUILayout.ObjectField(
               obj: linkedTerrain,
               objType: typeof(Terrain),
               true) as Terrain;

        linkedMeshFilter = EditorGUILayout.ObjectField(
               obj: linkedMeshFilter,
               objType: typeof(MeshFilter),
               true) as MeshFilter;

        if (GUILayout.Button("Punch hole"))
        {
            PunchHole();
        }
    }

    void PunchHole()
    {
        //Prepare terrain info:
        TerrainData terrainData;
        terrainData = linkedTerrain.terrainData;
        int heightMapSize = terrainData.heightmapResolution;
        Vector2 gridSize = new Vector2(terrainData.size.x, terrainData.size.z) * (1f / (heightMapSize - 1));
        bool[,] holes = terrainData.GetHoles(0, 0, terrainData.holesResolution, terrainData.holesResolution);

        //Get mesh size:
        Quaternion boundingBoxRotation = linkedMeshFilter.transform.rotation;
        Vector3 boundingBoxCenter = linkedMeshFilter.transform.position + boundingBoxRotation * linkedMeshFilter.sharedMesh.bounds.center;
        Vector3 boundingBoxSize = linkedMeshFilter.sharedMesh.bounds.size;
        Vector3 scaledBoundingBoxSize = 0.5f * new Vector3(
            linkedMeshFilter.transform.lossyScale.x * boundingBoxSize.x,
            linkedMeshFilter.transform.lossyScale.y * boundingBoxSize.y,
            linkedMeshFilter.transform.lossyScale.z * boundingBoxSize.z);
        
        if (tempMesh == null) tempMesh = new Mesh();

        tempMesh.triangles = new int[0];

        tempMesh.vertices = new Vector3[]
        {
            boundingBoxCenter + boundingBoxRotation * new Vector3(scaledBoundingBoxSize.x, scaledBoundingBoxSize.y, scaledBoundingBoxSize.z),
            boundingBoxCenter + boundingBoxRotation * new Vector3(scaledBoundingBoxSize.x, scaledBoundingBoxSize.y, -scaledBoundingBoxSize.z),
            boundingBoxCenter + boundingBoxRotation * new Vector3(scaledBoundingBoxSize.x, -scaledBoundingBoxSize.y, scaledBoundingBoxSize.z),
            boundingBoxCenter + boundingBoxRotation * new Vector3(scaledBoundingBoxSize.x, -scaledBoundingBoxSize.y, -scaledBoundingBoxSize.z),
            boundingBoxCenter + boundingBoxRotation * new Vector3(-scaledBoundingBoxSize.x, scaledBoundingBoxSize.y, scaledBoundingBoxSize.z),
            boundingBoxCenter + boundingBoxRotation * new Vector3(-scaledBoundingBoxSize.x, scaledBoundingBoxSize.y, -scaledBoundingBoxSize.z),
            boundingBoxCenter + boundingBoxRotation * new Vector3(-scaledBoundingBoxSize.x, -scaledBoundingBoxSize.y, scaledBoundingBoxSize.z),
            boundingBoxCenter + boundingBoxRotation * new Vector3(-scaledBoundingBoxSize.x, -scaledBoundingBoxSize.y, -scaledBoundingBoxSize.z)
        };

        tempMesh.RecalculateBounds();

        //Get new mesh bounds
        /*
        Vector2Int bottomLeftCorner = new Vector2Int(
            boundingBoxCenter.x - tempMesh.bounds.size.x);
        */
    }
}
#endif