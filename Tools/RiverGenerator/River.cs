using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace iffnsStuff.iffnsUnityTools.WorldBuildingTools
{
    public class River : MonoBehaviour
    {
        [SerializeField] Transform waypointHolder;

        Mesh linkedMesh
        {
            get
            {
                return transform.GetComponent<MeshFilter>().sharedMesh;
            }
            set
            {
                transform.GetComponent<MeshFilter>().sharedMesh = value;
            }
        }

        public int NumberOfWaypoints
        {
            get
            {
                if (waypointHolder == null) return 0;

                return waypointHolder.childCount;
            }
        }

        public void MakeMeshUniqueAndUpdate()
        {
            linkedMesh = new Mesh();

            UpdateRiverMesh();
        }

        public void UpdateRiverMesh()
        {
            if(linkedMesh == null)
                linkedMesh = new Mesh();

            //Reserve values
            int waypointCount = NumberOfWaypoints;

            Vector3[] vertices = new Vector3[waypointCount * 2];
            Vector2[] UVs = new Vector2[waypointCount * 2];
            int[] triangles = new int[(waypointCount - 1) * 6];

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

            vertices[0] = transform.InverseTransformPoint(helper.position - halfWidth * helper.right);
            vertices[1] = transform.InverseTransformPoint(helper.position + halfWidth * helper.right);
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

                vertices[waypoint * 2 + 0] = transform.InverseTransformPoint(helper.position - halfWidth * helper.right);
                vertices[waypoint * 2 + 1] = transform.InverseTransformPoint(helper.position + halfWidth * helper.right);

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

            vertices[lastWaypointIndex * 2 + 0] = transform.InverseTransformPoint(helper.position - halfWidth * helper.right);
            vertices[lastWaypointIndex * 2 + 1] = transform.InverseTransformPoint(helper.position + halfWidth * helper.right);

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
            linkedMesh.Clear();

            linkedMesh.vertices = vertices;
            linkedMesh.triangles = triangles;
            linkedMesh.uv = UVs;

            linkedMesh.RecalculateBounds();
            linkedMesh.RecalculateNormals();
            linkedMesh.RecalculateTangents();
        }
    }
}


