using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;

public class GizmosDrawer : MonoBehaviour
{
    void OnDrawGizmos()
    {
        
        foreach(Vector3 vertex in TerrainHoleTest.vertices)
        {
            Gizmos.DrawWireCube(vertex, new Vector3(0.1f, 0.1f, 0.1f));
        }
        
    }
}
