import math

# --- THE DIGITAL MAP OF YOUR ROOM ---
BEACON_LOCATIONS = {
    "Node_A": (0.0, 0.0),   # Bottom Left (Android - offline)
    "Node_B": (5.0, 0.0),   # Bottom Right (iPhone 1 - Target)
    "Node_C": (2.5, 5.0)    # Top Center (iPhone 2)
}

def rssi_to_distance(rssi, tx_power=-59, environmental_factor=2.5):
    if rssi is None or rssi == 0:
        return 10.0
    return 10.0 ** ((tx_power - rssi) / (10.0 * environmental_factor))

def calculate_position(ble_data):
    found_beacons = []
    
    for beacon in ble_data:
        b_id = beacon.get('id', '')
        rssi = beacon.get('rssi')
        
        if b_id in BEACON_LOCATIONS and rssi is not None:
            dist = rssi_to_distance(rssi)
            found_beacons.append({
                "pos": BEACON_LOCATIONS[b_id],
                "dist": dist
            })
            
    if len(found_beacons) == 0:
        return 2.5, 2.5  

    if len(found_beacons) == 1:
        return found_beacons[0]["pos"]

    if len(found_beacons) == 2:
        # THE EMERGENCY 2-BEACON SLIDER
        p1, p2 = found_beacons[0]["pos"], found_beacons[1]["pos"]
        d1, d2 = found_beacons[0]["dist"], found_beacons[1]["dist"]
        
        w1 = 1 / (d1 + 1e-5)
        w2 = 1 / (d2 + 1e-5)
        total_w = w1 + w2
        
        x = (p1[0] * w1 + p2[0] * w2) / total_w
        y = (p1[1] * w1 + p2[1] * w2) / total_w
        return round(x, 2), round(y, 2)

    # FULL 3-NODE POSITIONING (If Node A ever comes back online)
    total_inv_dist = sum(1/(b["dist"] + 1e-5) for b in found_beacons)
    x = sum(b["pos"][0] * (1/(b["dist"] + 1e-5)) for b in found_beacons) / total_inv_dist
    y = sum(b["pos"][1] * (1/(b["dist"] + 1e-5)) for b in found_beacons) / total_inv_dist
    return round(x, 2), round(y, 2)