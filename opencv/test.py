import cv2

# Try index 0, 1, or 2. 
# Usually, 0 is the iPhone (Continuity) and 1 or 2 is the Built-in.
# Let's try to loop through them to find the one that works.

def open_camera():
    for index in [1, 2, 0]: # Check built-in options first, then iPhone
        cap = cv2.VideoCapture(index)
        if cap.isOpened():
            ret, frame = cap.read()
            if ret:
                print(f"Success! Using camera index: {index}")
                return cap
            cap.release()
    return None

cap = open_camera()

if cap is None:
    print("Error: Could not find any working camera.")
    exit()

while True:
    ret, frame = cap.read()
    if not ret:
        break

    cv2.imshow('Camera Feed', frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()