using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Coordinate : MonoBehaviour {

	public Transform point;

	// Update is called once per frame
	void Update () {
		if(point != null){
			gameObject.GetComponent<Renderer>().sharedMaterial.SetVector("_Point", point.position);
		}
	}
}
