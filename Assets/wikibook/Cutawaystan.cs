using UnityEngine;
using System.Collections;

public class Cutawaystan : MonoBehaviour {

	public Renderer otherObject;

	[ExecuteInEditMode]
	void Update () {
		if(otherObject != null){
			gameObject.GetComponent<Renderer> ().sharedMaterial.SetMatrix (
				"_otherMatrix", 
				otherObject.GetComponent<Renderer>().worldToLocalMatrix
			);
		}
	}
}
