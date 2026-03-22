import networkx as nx
import math

# 1. Build the digital map (Graph) of the room
G = nx.Graph()

# Add our key locations with their (x, y) coordinates
G.add_node("Entrance", pos=(0.0, 0.0))
G.add_node("Middle", pos=(2.5, 2.5))
G.add_node("Exit", pos=(5.0, 5.0))

# Connect the nodes so the routing algorithm knows the pathways
G.add_edge("Entrance", "Middle", weight=1)
G.add_edge("Middle", "Exit", weight=1)

def get_optimal_path(current_x, current_y, destination="Exit"):
    """
    Finds the closest node to the user and calculates the shortest path to the destination.
    """
    try:
        # Step 1: Find the closest predefined node to the user's current raw coordinates
        closest_node = "Entrance"
        min_dist = float('inf')
        
        for node, data in G.nodes(data=True):
            nx_x, nx_y = data['pos']
            # Basic distance formula to find the nearest point
            dist = math.hypot(current_x - nx_x, current_y - nx_y)
            if dist < min_dist:
                min_dist = dist
                closest_node = node

        # Step 2: Calculate the shortest path 
        # THE FIX: networkx specifically requires 'source' and 'target' as arguments!
        path = nx.shortest_path(G, source=closest_node, target=destination, weight='weight')

        # Step 3: Determine the very next waypoint to walk towards
        if len(path) > 1:
            next_node = path[1] 
        else:
            next_node = path[0] # We are already at the destination!

        return {
            "path": path,
            "next_node": next_node
        }

    except Exception as e:
        # Fallback just in case someone asks for a destination that doesn't exist
        print(f"Routing Warning: {e}")
        return {"path": ["Entrance", "Exit"], "next_node": "Exit"}