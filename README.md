# Hackathon Technical Disclosure & Compliance Document

## Team Information
- **Team Name**:HackHers
- **Project Title**:GeoPulse
- **Problem Statement / Track**:create a beacon type of device that can help indoor and outdoor positionong .you can use a cluster of smatphones and utiliztatement firster the sensors for simulation 
- **Team Members**:Kavyaa Purohit,Sampati Dotasara
- **Repository Link (if public)**:https://github.com/KavyaaPur/IOPS
- **Deployment Link (if applicable)**:

---
## 1. APIs & External Services Used

### API / Service Entry Project**:

**API / Service Name**:IBM Quantum Cloud API
- **Provider / Organization**:IBM
- **Purpose in:Solving the Quadratic Unconstrained Binary Optimization (QUBO) matrix for the shortest, obstacle-free indoor path.
- **API Type**:
  - [ ] REST
  - [ ] GraphQL
  - [ .] SDK(Qiskit)
  - [ ] Other (specify)
- **License Type**:
  - [ ] Open Source
  - [ .] Free Tier(IBM Quantum Learning/Open Plan)
  - [ ] Academic
  - [ ] Commercial

  License Link / Documentation URL: https://quantum.ibm.com/

  **Rate Limits (if any)**:Limited by "Fair Share" queue/Job credits.
- **Commercial Use Allowed**:
  - [ ] Yes
  - [ ] No
  - [.] Unclear(Dependent on Open Plan TOS)

**API / Service Name**:Google Firebase / Firestore
- **Provider / Organization**:Google
- **Purpose in:Real-time synchronization of sensor data between the "Anchor" smartphones and the "Mobile" node.
- **API Type**:
  - [ ] REST
  - [ ] GraphQL
  - [.] SDK
  - [ ] Other (specify)
- **License Type**:
  - [ ] Open Source
  - [.] Free Tier(Spark Plan)
  - [ ] Academic
  - [ ] Commercial
  License Link / Documentation URL: https://firebase.google.com/support/privacy

  **Rate Limits (if any)**:50,000 reads/day, 20,000 writes/day (Free Tier).

- **Commercial Use Allowed**:
  - [.] Yes
  - [ ] No
  - [] Unclear

  ## 2. API Keys & Credentials Declaration

Teams **must disclose how API keys or credentials are obtained and handled**.

- **API Key Source**:
  - [.] Self-generated from official provider
  - [ ] Hackathon-provided key
  - [ ] Open / Keyless API
- **Key Storage Method**:
  - [.] Environment Variables
  - [ ] Secure Vault
  - [ ] Backend-only (not exposed)
- **Hardcoded in Repository**:
  - [ ] Yes 
  - [.] No 

## 3. Open Source Libraries & Frameworks

| Name              | Version            | Purpose                                    | License                 |

|Flutter           |3.x                 |Cross-platform Mobile UI	                 |BSD-3                    |

|Qiskit	           |1.0.x	            |Quantum Circuit & QUBO formulation	         |Apache 2.0               |

|Flutter Blue Plus |Latest	            |BLE scanning and beacon simulation	         |BSD-3                    |

|NumPy	           |1.2x	            |Matrix math for Trilateration	             |BSD                      |

|Scipy	           |1.1x	            |Signal processing & Kalman Filtering	     |BSD                      |


## 4. AI Models, Tools & Agents Used.

### AI Model 1:Optimization Brain
- **Model Name**:QAOA (Quantum Approximate Optimization Algorithm)
- **Provider**:IBM Qiskit Runtime
- **Used For** (e.g., summarization, vision, code generation):Pathfinding optimization. It processes the "Grid Matrix & Constraints" to find the "Optimal TSP Route Array" for the visually impaired user.
- **Access Method**:
  - [.] API
  - [ ] Local Model
  - [ ] Hosted Platform

  ### AI Model 2:Positioning Brain (Sensor Fusion)
- **Model Name**:Extended Kalman Filter (EKF) / Recursive Estimation Model
- **Provider**:Custom Implementation (via NumPy/SciPy)
- **Used For** (e.g., summarization, vision, code generation):Fusing noisy BLE RSSI data with high-frequency IMU data to predict smooth (X,Y) coordinates in the "Sensor Fusion" module.
- **Access Method**:
  - [ ] API
  - [.] Local Model
  - [ ] Hosted Platform

### AI Model 3:Coding & Logic Assistant
- **Model Name**:Gemini 1.5 Flash
- **Provider**:Google
- **Used For** (e.g., summarization, vision, code generation):Generating the JSON Payload structure, debugging Bluetooth connectivity logic, and designing the Spatial Audio panning mathematics.
- **Access Method**:
  - [ ] API
  - [ ] Local Model
  - [.] Hosted Platform

  ### AI Tools / Platforms: IBM Qiskit SDK
- **Tool Name**:Translating navigation constraints into a QUBO (Quadratic Unconstrained Binary Optimization) format for the quantum backend.
- **Role in Project**:
- **Level of Dependency**:
  - [ ] Assistive
  - [.] Core Logic
  - [ ] Entire Solution

## 5. AI Agent Usage Declaration (IMPORTANT)

The following must be declared clearly:

- **AI Agents Used** (if any):
  - [ ] None
  - [•] Yes (Google Gemini / GitHub Copilot)
  If Yes:
    Agent Name / Platform: Google Gemini 1.5 & GitHub Copilot
    Capabilities Used:
        [•] Code generation (Refining boilerplate and math functions)
        [ ] Full app scaffolding
        [•] Decision making (Selecting the Kalman Filter over simple averaging)
        [ ] Autonomous workflows
    Human Intervention Level:
        [•] High (manual design & logic)
        [ ] Medium
        [ ] Low (mostly autonomous)

      
## 6. Restricted / Discouraged AI Services
Statement of Compliance:
Our team did not use any fully autonomous or "prompt-to-product" platforms (such as Lovable, Bolt.new, or v0) to generate the application end-to-end. We maintained full control over the system design and implementation.

### Restricted (Must Be Declared & Justified)
Justification for AI Assistance:
AI was used as a technical consultant and pair programmer to accelerate the development of specific mathematical and boilerplate components. Our usage is justified as follows:

    Human-Led Architecture: The decision to use a distributed smartphone cluster as hardware beacons and a Python-based REST API for backend processing was a human architectural decision designed to optimize battery life and computational power.

    Modular Implementation: We used AI (Gemini 1.5) to assist in writing the Kalman Filter state-transition matrices and the JSON Schema for sensor data packets. These are isolated technical components that were manually integrated into our custom codebase.

    Manual Decision Making: Every optimization constraint sent to the IBM Qiskit API was manually defined based on the physical layout of the testing environment. The AI did not make "black-box" decisions regarding the navigation logic.


## 7. Originality & Human Contribution Statement

Designed and Implemented by humans:

    Hardware Architecture: The conceptualization and physical setup of the Smartphone Beacon Cluster. We manually configured multiple devices to act as a synchronized BLE (Bluetooth Low Energy) environment, which is a custom hardware-software bridge.

    System Logic & Data Flow: The end-to-end architecture—from the Client-side JSON Payload Generator to the Backend REST API—was designed by the team to ensure low-latency communication.

    Mathematical Modeling: While AI assisted with syntax, the team manually defined the Trilateration Engine logic and the QUBO (Quadratic Unconstrained Binary Optimization) constraints required for the IBM Qiskit Quantum API.

    Accessibility UX: The Spatial Audio feedback system (Left/Right chimes) was specifically designed by the team to meet the unique orientation needs of visually impaired users.


Assisted by AI

Algorithmic Optimization (Kalman Filter):
We utilized Gemini 1.5 Flash to refine the mathematical state-transition matrices for the Extended Kalman Filter (EKF). While the logic of fusing IMU and BLE data was human-designed (see DFD Process 2.0), the AI assisted in optimizing the Python code for real-time execution on the Backend Server.

Quantum Circuit Formulation (QUBO):
The AI assisted in translating our human-defined navigation constraints (obstacles, distance, and grid nodes) into the specific QUBO (Quadratic Unconstrained Binary Optimization) mathematical format required by the IBM Qiskit SDK. This ensured that the "Optimal TSP Route Array" was calculated with high precision.

Spatial Audio Panning Logic:
To achieve the "Left/Right Audio Chimes" seen in the Architecture Diagram, AI was used to help calculate the trigonometric functions required for 3D spatial positioning. This allows the user to "hear" the direction of the next node relative to their current orientation (x,y,θ).

    

    What Makes Our Solution Unique

    Hardware Sustainability (E-Waste Upscaling): Unlike traditional indoor navigation that requires expensive dedicated iBeacons, our project repurposes old smartphones as high-precision beacons, turning potential e-waste into a life-saving community tool.

    Quantum-Classical Hybridization: We bridge the gap between everyday mobile sensors and Quantum-inspired optimization. By offloading pathfinding to the IBM Quantum Cloud, we achieve route optimization that considers complex indoor obstacles in a way standard GPS-based apps cannot.

    Edge-to-Cloud Integration: Our system successfully integrates high-frequency IMU (Inertial Measurement Unit) data from the edge with cloud-based Quantum computing, providing a level of precision (down to sub-meter accuracy) that is rare in DIY navigation prototypes.

## 8. Ethical, Legal & Compliance Checklist

- [.] No copyrighted data used without permission
- [.] No leaked or private datasets
- [.] API usage complies with provider TOS
- [.] No malicious automation or scraping
- [.] No AI-generated plagiarism

## 9. Final Declaration

 We confirm that all information provided above is accurate.  
 We understand that misrepresentation may lead to disqualification.

 Team Representative Name:Kavyaa Purohit
