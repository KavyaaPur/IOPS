import numpy as np

class KalmanFilter2D:
    def __init__(self, initial_x=0.0, initial_y=0.0):
        """
        Initializes the Filter.
        """
        # State vector: [X_position, Y_position]
        self.state = np.array([[initial_x], [initial_y]])
        
        # Covariance matrix (P) - How much we doubt our current state
        self.P = np.eye(2) * 1.0 
        
        # Measurement matrix (H) - Maps state to measurement
        self.H = np.eye(2)
        
        # Measurement Noise (R) - How 'bouncy' is the Bluetooth? 
        # Higher number = we trust the BLE less and rely more on footsteps.
        self.R = np.eye(2) * 5.0
        
        # Process Noise (Q) - How much do we drift while walking? 
        # Higher number = we trust the IMU less.
        self.Q = np.eye(2) * 0.5 

    def predict(self, step_length, yaw_angle_radians):
        """
        PHASE 1: Predict the new position using IMU Dead Reckoning (Steps & Compass).
        Called every time the phone detects a footstep.
        """
        # Calculate movement vector based on compass heading
        dx = step_length * np.cos(yaw_angle_radians)
        dy = step_length * np.sin(yaw_angle_radians)
        
        # Update our assumed state
        self.state[0][0] += dx
        self.state[1][0] += dy
        
        # Increase uncertainty since we are moving blindly between BLE readings
        self.P = self.P + self.Q
        
        return self.state[0][0], self.state[1][0]

    def update(self, ble_x, ble_y):
        """
        PHASE 2: Correct the prediction using the BLE Trilateration data.
        Called every time we get a fresh ping from the beacon cluster.
        """
        # Formulate the measurement vector from trilateration
        Z = np.array([[ble_x], [ble_y]])
        
        # Innovation (Difference between actual BLE measurement and our prediction)
        Y = Z - np.dot(self.H, self.state)
        
        # Kalman Gain (The magic formula: How much do we trust BLE vs. our Prediction?)
        S = np.dot(self.H, np.dot(self.P, self.H.T)) + self.R
        K = np.dot(np.dot(self.P, self.H.T), np.linalg.inv(S))
        
        # Final Corrected State Update
        self.state = self.state + np.dot(K, Y)
        
        # Decrease uncertainty because we just locked onto a fixed BLE reference point
        I = np.eye(2)
        self.P = np.dot((I - np.dot(K, self.H)), self.P)
        
        return round(self.state[0][0], 2), round(self.state[1][0], 2)

# --- Quick Singleton Wrapper for the Flask App ---
# This ensures we maintain the same filter state across multiple API calls
active_filter = None

def update_position(raw_x, raw_y, imu_data, current_yaw_radians):
    global active_filter
    
    if active_filter is None:
        active_filter = KalmanFilter2D(initial_x=raw_x, initial_y=raw_y)
    
    # Check if a step was detected in the IMU data (simplified for the payload)
    step_detected = imu_data.get('step_detected', False)
    step_length = 0.65 # Average human step length in meters
    
    if step_detected:
        active_filter.predict(step_length, current_yaw_radians)
        
    # Always update with the latest BLE coordinate
    smoothed_x, smoothed_y = active_filter.update(raw_x, raw_y)
    
    return smoothed_x, smoothed_y