class_name Predictor extends Object
#Returns, in local space, the calculated position of a projectile fired from our position, at a predicted velocity. 
#To use, face the returned local position and fire a projectile to it, depending on contruction, may need to offset by PI / 2
static func getLinearInterceptPosition2D(relativePosition := Vector2.ZERO, relativeVelocity := Vector2.ZERO, impliedVelocity := 1.0, precision := 10.0, timeoutCount := 10, DEBUG := false) -> Vector2 : 
	var iterComp := func(recursiveCall : Callable, relPos : Vector2, relVel : Vector2 ,  impliedVelocity : float,count : int, previousttt : float = 0) -> Vector2 :
		count -= 1
		var timeToTarget = relPos.length() / impliedVelocity
		var relPosIterated = relPos + relVel * (timeToTarget - previousttt)
		if (DEBUG) : printt("iteration_depth: ", count , "relPos: " , relPos, "RPI: ", relPosIterated, "variance: ", (relPosIterated - relPos).length())
		return recursiveCall.call(relPosIterated, relVel, impliedVelocity, count, timeToTarget ) if count > 0  and !( (relPosIterated - relPos).length() < precision )else relPosIterated
	return iterComp.call(iterComp, relativePosition, relativeVelocity, impliedVelocity, timeoutCount, precision)
