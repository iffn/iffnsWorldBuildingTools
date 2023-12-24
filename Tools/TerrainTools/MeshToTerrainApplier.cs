# if UNITY_EDITOR
using UnityEngine;
using UnityEditor;

namespace iffnsStuff.iffnsUnityTools.TerrainTools
{
    public class MeshToTerrainApplier : EditorWindow
    {
        public enum ModificationTypes
        {
            HardApply,
            UseMaxHeight,
            UseMinHeihgt
        }

        Terrain linkedTerrain;
        Collider linkedCollider;
        ModificationTypes modificationType = ModificationTypes.HardApply;

        [MenuItem("Tools/iffnsStuff/WorldBuildingTools/MeshToTerrainApplier")]
        public static void ShowWindow()
        {
            GetWindow(typeof(MeshToTerrainApplier), false, "Mesh to terrain appliler");
        }

        void OnGUI()
        {
            GUILayout.Label(text: "Mesh to terrain applier", style: EditorStyles.boldLabel);

            linkedTerrain = EditorGUILayout.ObjectField(
               obj: linkedTerrain,
               objType: typeof(Terrain),
               true) as Terrain;

            linkedCollider = EditorGUILayout.ObjectField(
               obj: linkedCollider,
               objType: typeof(Collider),
               true) as Collider;

            modificationType = (ModificationTypes)EditorGUILayout.EnumPopup("Modification type", modificationType);

            if (linkedTerrain != null && linkedCollider != null)
            {
                TerrainData terrainData = linkedTerrain.terrainData;

                if (GUILayout.Button("Apply meshes"))
                {
                    ApplyMeshesToTerrain();
                }
            }
        }

        void ApplyMeshesToTerrain()
        {
            TerrainData terrainData;
            terrainData = linkedTerrain.terrainData;
            int heightMapSize = terrainData.heightmapResolution;

            Vector2 gridSize = new Vector2(terrainData.size.x, terrainData.size.z) * (1f / (heightMapSize - 1));

            float[,] heights = terrainData.GetHeights(0, 0, heightMapSize, heightMapSize);
            float max = -Mathf.Infinity;

            float meshHeightInverse = 1 / terrainData.heightmapScale.y;

            for (int x = 0; x < terrainData.heightmapResolution; x++)
            {
                for (int z = 0; z < terrainData.heightmapResolution; z++)
                {
                    float xPos = x * gridSize.x + linkedTerrain.transform.position.x;
                    float zPos = z * gridSize.y + linkedTerrain.transform.position.z;

                    Ray ray = new Ray(new Vector3(xPos, 10000, zPos), Vector3.down);

                    if (linkedCollider.Raycast(ray, out RaycastHit hit, Mathf.Infinity))
                    {
                        float height = (hit.point.y - linkedTerrain.transform.position.y) * meshHeightInverse;

                        switch (modificationType)
                        {
                            case ModificationTypes.HardApply:
                                heights[z, x] = height;
                                break;
                            case ModificationTypes.UseMaxHeight:
                                heights[z, x] = (height > heights[z, x]) ? height : heights[z, x];
                                break;
                            case ModificationTypes.UseMinHeihgt:
                                heights[z, x] = (height > heights[z, x]) ? heights[z, x] : height;
                                break;
                            default:
                                Debug.LogWarning("Error: Enum type not known");
                                return;
                        }

                        

                        if (max < hit.point.y) max = hit.point.y;
                    }
                }
            }

            terrainData.SetHeights(0, 0, heights);
        }
    }
}
#endif