#if UNITY_EDITOR

using UnityEngine;
using UnityEditor;
using UnityEditor.Build;
using UnityEditor.Build.Reporting;

namespace iffnsStuff.iffnsUnityTools.Utilities
{
    public class DestroyOnBuild : MonoBehaviour
    {
        // Marker only
    }

    public class DestroyOnBuildProcessor : IProcessSceneWithReport
    {
        public int callbackOrder => 0;

        public void OnProcessScene(UnityEngine.SceneManagement.Scene scene, BuildReport report)
        {
            DestroyOnBuild[] destroyOnBuilds = Object.FindObjectsOfType<DestroyOnBuild>();
            foreach (DestroyOnBuild dob in destroyOnBuilds)
            {
                Object.DestroyImmediate(dob.gameObject);
            }
        }
    }
}

#endif
