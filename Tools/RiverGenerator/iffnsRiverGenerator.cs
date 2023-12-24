# if UNITY_EDITOR
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace iffnsStuff.iffnsUnityTools.WorldBuildingTools
{
    public class iffnsRiverGenerator : EditorWindow
    {
        MeshFilter LinkedMesh;

        int NumberOfWaypoints
        {
            get
            {
                if (LinkedMesh == null) return 0;

                if (LinkedMesh.transform.childCount == 0) return 0;

                return LinkedMesh.transform.GetChild(0).childCount;
            }
        }

        [MenuItem("Tools/iffnsStuff/WorldBuildingTools/RiverGenerator")]
        public static void ShowWindow()
        {
            GetWindow(typeof(iffnsRiverGenerator), false, "River generator");
        }

        void OnGUI()
        {
            GUILayout.Label("iffns River Generator");

            LinkedMesh = EditorGUILayout.ObjectField(
               obj: LinkedMesh,
               objType: typeof(MeshFilter),
               true) as MeshFilter;

            if (!LinkedMesh)
            {
                if (GUILayout.Button("Instantiate river template"))
                {
                    InstantiateRiverHolder();
                }
            }
            else if (NumberOfWaypoints < 2)
            {
                GUILayout.Label("Please add more waypoints to the river. (Children of first child)");
            }
            else
            {
                if (GUILayout.Button("Update river mesh"))
                {
                    GenerateRiver();
                }
            }
        }

        void InstantiateRiverHolder()
        {
            GameObject newRiver = new GameObject("River");

            LinkedMesh = newRiver.AddComponent<MeshFilter>();
            newRiver.AddComponent<MeshRenderer>();

            GameObject holder = new GameObject("Waypoint holder");
            holder.transform.parent = newRiver.transform;

            GameObject waypoint0 = new GameObject("Waypoint 0");
            waypoint0.transform.parent = holder.transform;

            GameObject waypoint1 = new GameObject("Waypoint 1");
            waypoint1.transform.parent = holder.transform;
            waypoint1.transform.position = Vector3.forward;
        }

        void GenerateRiver()
        {
            if (LinkedMesh.sharedMesh == null)
            {
                LinkedMesh.sharedMesh = new Mesh();
            }

            //Reserve values
            int waypointCount = NumberOfWaypoints;

            Vector3[] vertices = new Vector3[waypointCount * 2];
            Vector2[] UVs = new Vector2[waypointCount * 2];
            int[] triangles = new int[(waypointCount - 1) * 6];

            Transform linkedMeshTransform = LinkedMesh.transform;
            Transform waypointHolder = linkedMeshTransform.GetChild(0);

            Transform[] waypoints = new Transform[waypointCount];


            for (int i = 0; i < waypointCount; i++)
            {
                waypoints[i] = waypointHolder.GetChild(i);
            }

            //Assign positions
            Transform currenWaypoint = waypoints[0];
            Transform prevWaypoint = null;

            Transform helper = new GameObject().transform;
            helper.position = waypoints[0].position;
            helper.LookAt(waypoints[1], Vector3.up);

            float halfWidth = waypoints[0].localScale.x * 0.5f;

            vertices[0] = linkedMeshTransform.InverseTransformPoint(helper.position - halfWidth * helper.right);
            vertices[1] = linkedMeshTransform.InverseTransformPoint(helper.position + halfWidth * helper.right);
            UVs[0] = new Vector2(-halfWidth, 0);
            UVs[1] = new Vector2(halfWidth, 0);

            float currentPosition = 0;

            Vector3 headingCoordinates = helper.forward;
            currenWaypoint.LookAt(currenWaypoint.position + new Vector3(headingCoordinates.x, 0, headingCoordinates.z));

            for (int waypoint = 1; waypoint < waypointCount - 1; waypoint++)
            {
                Transform currentWaypoint = waypoints[waypoint];
                prevWaypoint = waypoints[waypoint - 1];
                Transform nextWaypoint = waypoints[waypoint + 1];

                helper.SetPositionAndRotation(
                    waypoints[waypoint].position,
                    Quaternion.LookRotation((nextWaypoint.position - currentWaypoint.position).normalized + (currentWaypoint.position - prevWaypoint.position).normalized, Vector3.up)
                    );

                halfWidth = waypoints[waypoint].localScale.x * 0.5f;

                vertices[waypoint * 2 + 0] = linkedMeshTransform.InverseTransformPoint(helper.position - halfWidth * helper.right);
                vertices[waypoint * 2 + 1] = linkedMeshTransform.InverseTransformPoint(helper.position + halfWidth * helper.right);

                currentPosition += (currentWaypoint.position - prevWaypoint.position).magnitude * currentWaypoint.localScale.z;

                UVs[waypoint * 2 + 0] = new Vector2(-halfWidth, currentPosition);
                UVs[waypoint * 2 + 1] = new Vector2(halfWidth, currentPosition);

                headingCoordinates = helper.forward;

                waypoints[waypoint].LookAt(waypoints[waypoint].position + new Vector3(headingCoordinates.x, 0, headingCoordinates.z));
            }

            int lastWaypointIndex = waypointCount - 1;
            currenWaypoint = waypoints[waypointCount - 1];
            prevWaypoint = waypoints[waypointCount - 2];

            helper.position = prevWaypoint.position;
            helper.LookAt(currenWaypoint, Vector3.up);
            helper.position = currenWaypoint.position;

            halfWidth = currenWaypoint.localScale.x * 0.5f;

            vertices[lastWaypointIndex * 2 + 0] = linkedMeshTransform.InverseTransformPoint(helper.position - halfWidth * helper.right);
            vertices[lastWaypointIndex * 2 + 1] = linkedMeshTransform.InverseTransformPoint(helper.position + halfWidth * helper.right);

            currentPosition += (currenWaypoint.position - prevWaypoint.position).magnitude * currenWaypoint.localScale.z;

            UVs[lastWaypointIndex * 2 + 0] = new Vector2(-halfWidth, currentPosition);
            UVs[lastWaypointIndex * 2 + 1] = new Vector2(halfWidth, currentPosition);

            headingCoordinates = helper.forward;
            currenWaypoint.LookAt(currenWaypoint.position + new Vector3(headingCoordinates.x, 0, headingCoordinates.z));

            DestroyImmediate(helper.gameObject);

            //Set triangles
            for (int waypoint = 0; waypoint < waypointCount - 1; waypoint++)
            {
                triangles[waypoint * 6 + 0] = waypoint * 2 + 0;
                triangles[waypoint * 6 + 1] = waypoint * 2 + 2;
                triangles[waypoint * 6 + 2] = waypoint * 2 + 1;

                triangles[waypoint * 6 + 3] = waypoint * 2 + 1;
                triangles[waypoint * 6 + 4] = waypoint * 2 + 2;
                triangles[waypoint * 6 + 5] = waypoint * 2 + 3;
            }

            //Assign values
            Mesh mesh = LinkedMesh.sharedMesh;

            mesh.vertices = vertices;
            mesh.triangles = triangles;
            mesh.uv = UVs;

            mesh.RecalculateBounds();
            mesh.RecalculateNormals();
            mesh.RecalculateTangents();
        }
    }
}
#endif

