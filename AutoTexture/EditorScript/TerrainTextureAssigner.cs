# if UNITY_EDITOR
using UnityEditor;
using UnityEngine;

namespace iffnsStuff.iffnsUnityTools.WorldBuildingTools
{
    public class TerrainTextureAssigner : EditorWindow
    {
        Material SteepnessMaterial;
        Material TexturedMaterial;
        Material MapMaterial;

        [MenuItem("Tools/iffnsStuff/WorldBuildingTools/TerrainTextureAssigner")]
        public static void ShowWindow()
        {
            GetWindow(t: typeof(TerrainTextureAssigner), utility: false, title: "Terrain texture assigner");
        }


        void OnGUI()
        {
            GUILayout.Label("Terrain Texture Assigner");

            GUILayout.Label("Steepness material");
            SteepnessMaterial = EditorGUILayout.ObjectField(
               obj: SteepnessMaterial,
               objType: typeof(Material),
               true) as Material;

            if (SteepnessMaterial)
            {
                if (GUILayout.Button("Assign steepness to all terrains"))
                {
                    AssignToAllTerrains(SteepnessMaterial);
                }
            }

            GUILayout.Label("Textured material");
            TexturedMaterial = EditorGUILayout.ObjectField(
               obj: TexturedMaterial,
               objType: typeof(Material),
               true) as Material;

            if (TexturedMaterial)
            {
                if (GUILayout.Button("Assign textures to all terrains"))
                {
                    AssignToAllTerrains(TexturedMaterial);
                }
            }

            GUILayout.Label("Map material");
            MapMaterial = EditorGUILayout.ObjectField(
               obj: MapMaterial,
               objType: typeof(Material),
               true) as Material;

            if (MapMaterial)
            {
                if (GUILayout.Button("Assign map to all terrains"))
                {
                    AssignToAllTerrains(MapMaterial);
                }
            }
        }

        void AssignToAllTerrains(Material material)
        {
            Terrain[] allTerrains = FindObjectsOfType<Terrain>();

            foreach (Terrain terrain in allTerrains)
            {
                terrain.materialTemplate = material;
            }
        }

    }
}
#endif
