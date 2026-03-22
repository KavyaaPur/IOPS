import math

def calculate_relative_angle(current_x, current_y, current_yaw_deg, target_x, target_y):
    """
    Calculates the relative angle between the user's current heading 
    and the target destination.
    """
    # 1. Calculate the absolute angle to the target
    delta_x = target_x - current_x
    delta_y = target_y - current_y
    
    # math.atan2 returns angle in radians, convert to degrees
    target_angle_rad = math.atan2(delta_y, delta_x)
    target_angle_deg = math.degrees(target_angle_rad)
    
    # 2. Calculate the difference between where we are looking and where we need to go
    relative_angle = target_angle_deg - current_yaw_deg
    
    # 3. Normalize the angle to be between -180 and +180 degrees
    relative_angle = (relative_angle + 180) % 360 - 180
    
    return relative_angle

def generate_spatial_audio_cue(current_x, current_y, current_yaw_deg, next_node_x, next_node_y):
    """
    Translates the relative angle into a natural language instruction 
    and a stereo audio panning value (-1.0 to 1.0).
    """
    # Check if we have arrived (within 0.5 meters)
    distance_to_target = math.sqrt((next_node_x - current_x)**2 + (next_node_y - current_y)**2)
    if distance_to_target < 0.5:
        return {
            "instruction": "You have arrived at the next waypoint.",
            "audio_pan": 0.0,
            "status": "arrived"
        }

    angle = calculate_relative_angle(current_x, current_y, current_yaw_deg, next_node_x, next_node_y)
    
    # Map the angle to a human instruction and an audio pan value
    # Pan: -1.0 is full Left ear, 1.0 is full Right ear, 0.0 is center.
    if -15 <= angle <= 15:
        instruction = "Walk straight"
        pan = 0.0
    elif 15 < angle <= 45:
        instruction = "Turn slight right"
        pan = 0.5
    elif 45 < angle <= 135:
        instruction = "Turn right"
        pan = 1.0
    elif -45 <= angle < -15:
        instruction = "Turn slight left"
        pan = -0.5
    elif -135 <= angle < -45:
        instruction = "Turn left"
        pan = -1.0
    else:
        instruction = "Turn around"
        pan = 0.0 # Center sound, but maybe a different alert tone

    return {
        "instruction": instruction,
        "audio_pan": pan,
        "relative_angle": round(angle, 2),
        "status": "navigating"
    }

# --- Quick Test Block ---
if __name__ == "__main__":
    # Imagine user is at (0,0), facing North (90 degrees)
    # Target is at (5, 5) - which is North-East (45 degrees)
    # They need to turn Right (-45 degrees relative to them)
    
    result = generate_spatial_audio_cue(
        current_x=0.0, 
        current_y=0.0, 
        current_yaw_deg=90.0, 
        next_node_x=5.0, 
        next_node_y=5.0
    )
    
    print(f"Action: {result['instruction']}")
    print(f"Left/Right Ear Pan: {result['audio_pan']}")