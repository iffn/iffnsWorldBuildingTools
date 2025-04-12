# if UNITY_EDITOR
using iffnsStuff.MarchingCubeEditor.Core;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace iffnsStuff.iffnsUnityTools.WorldBuildingTools
{
    [CustomEditor(typeof(River))]
    public class RiverGenerator : Editor
    {
        River linkedRiver => (River)target;
        bool autoUpdateMesh;

        // Unity functions
        private void OnEnable()
        {
            
        }

        private void OnDisable()
        {
            SceneView.duringSceneGui -= AutoUpdateMesh;
            autoUpdateMesh = false;
        }

        public override void OnInspectorGUI()
        {
            DrawDefaultInspector();


            if (GUILayout.Button("Make river unique"))
            {
                linkedRiver.MakeMeshUniqueAndUpdate();
            }

            if (linkedRiver.NumberOfWaypoints < 2)
            {
                GUILayout.Label("Please add more waypoints to the river. (Children of first child)");
            }
            else
            {
                if (GUILayout.Button("Update river mesh"))
                {
                    linkedRiver.UpdateRiverMesh();
                }
            }

            bool newAutoUpdateMesh = EditorGUILayout.Toggle("Auto update",  autoUpdateMesh);

            if(autoUpdateMesh != newAutoUpdateMesh)
            {

                if(newAutoUpdateMesh)
                    SceneView.duringSceneGui += AutoUpdateMesh;
                else
                    SceneView.duringSceneGui -= AutoUpdateMesh;

                autoUpdateMesh = newAutoUpdateMesh;
            }
        }

        void AutoUpdateMesh(SceneView sceneView)
        {
            linkedRiver.UpdateRiverMesh();
        }
    }
}
#endif

