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

    Transform debugTransform1;
    Transform debugTransform2;
    Transform debugTransform3;

    [MenuItem("Tools/iffnsStuff/WorldBuildingTools/TerrainHolePuncher")]
    public static void ShowWindow()
    {
        GetWindow(typeof(TerrainHoleTest), false, "Terrain hole puncher");
    }

    Mesh tempMesh;

    void OnGUI()
    {
        GUILayout.Label(text: "Terrain hole puncher", style: EditorStyles.boldLabel);

        debugTransform1 = EditorGUILayout.ObjectField(
               obj: debugTransform1,
               objType: typeof(Transform),
               true) as Transform;

        debugTransform2 = EditorGUILayout.ObjectField(
               obj: debugTransform2,
               objType: typeof(Transform),
               true) as Transform;

        debugTransform3 = EditorGUILayout.ObjectField(
               obj: debugTransform3,
               objType: typeof(Transform),
               true) as Transform;

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

        if (GUILayout.Button("Draw gizmos"))
        {
            OnDrawGizmos();
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
        Vector2 bottomLeftCorner = new Vector2(
            (boundingBoxCenter.x - tempMesh.bounds.size.x * 0.5f),
            (boundingBoxCenter.z - tempMesh.bounds.size.z * 0.5f)
            );

        Vector2 topRightCorner = new Vector2(
            (boundingBoxCenter.x + tempMesh.bounds.size.x * 0.5f),
            (boundingBoxCenter.z + tempMesh.bounds.size.z * 0.5f)
            );

        Vector2Int bottomLeftCornerCounter = new Vector2Int(
            (int)(bottomLeftCorner.x / gridSize.x),
            (int)(bottomLeftCorner.y / gridSize.y)
            );

        Vector2Int topRightCornerCounter = new Vector2Int(
            (int)(topRightCorner.x / gridSize.x) + 1,
            (int)(topRightCorner.y / gridSize.y) + 1
            );

        bottomLeftCorner = new Vector2(
            bottomLeftCornerCounter.x * gridSize.x,
            bottomLeftCornerCounter.y * gridSize.y
            );

        topRightCorner = new Vector2(
            topRightCornerCounter.x * gridSize.x,
            topRightCornerCounter.y * gridSize.y
            );

        Vector2Int cornerOffset = topRightCornerCounter - bottomLeftCornerCounter;

        //Generate vertices
        List<Vector3> vertices = new List<Vector3>();
        for(int x = 0; x <= cornerOffset.x; x++)
        {
            for (int y = 0; y <= cornerOffset.y; y++)
            {
                vertices.Add(new Vector3(
                    x * gridSize.x + bottomLeftCorner.x,
                    0,
                    y * gridSize.y + bottomLeftCorner.y
                    ));
            }
        }

        TerrainHoleTest.vertices = vertices;

        debugTransform1.position = new Vector3(bottomLeftCorner.x, 0, bottomLeftCorner.y);
        debugTransform2.position = new Vector3(topRightCorner.x, 0, topRightCorner.y);
        debugTransform3.position = boundingBoxCenter;
    }

    public static List<Vector3> vertices = new List<Vector3>();

    public static void OnDrawGizmos()
    {
        /*
        Gizmos.DrawLine(
            Vector3.zero,
            Vector3.up
        );
        */
    }
}
#endif